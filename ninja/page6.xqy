(:
Copyright 2011 MarkLogic Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:)

xquery version "1.0-ml";

import module namespace template="http://try.marklogic.com/template" at "/lib/template.xqy";

template:apply(
    "Ninja!!!",
    <div>
        <h1>Constraints</h1>

        <p>Let's go back to the challenge of selecting messages from the database.  The
        following query uses a key-value constraint to limit the retrieval to mails
        posted to the Apache Maven announce mailing list:</p>

        <textarea id="sample19" class="code input-xquery output-xml">&lt;ul&gt;{{
    for $m in (/message[@list = "org.apache.maven.announce"])[1 to 10]
    return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>The predicate [@list = "org.apache.maven.announce"] says only to retrieve
        mails that have a list attribute with that value.  How does MarkLogic execute
        this query?  It doesn't exhaustively look at documents trying to find matches.
        It has indexes that can find these mails extremely fast.  How fast?  Let's
        check:</p>

        <textarea id="sample20" class="code input-xquery output-xml">xdmp:estimate(/message[@list = "org.apache.maven.announce"])
,
xdmp:elapsed-time()</textarea>

        <p>This counts the mails (there's 152 of them) and returns how long it took to do
        the work.  Yes, you need the comma.  As I said earlier, everything in XQuery
        is an expression and at the outermost level you can write either a singular
        expression or a sequence of expressions.  The comma makes it a sequence.</p>

        <p>I'm seeing an execution time of 0.1 milliseconds.  That's the raw time for
        MarkLogic indexes to isolate these 152 messages from the corpus of 5,000,000
        messages.</p>

        <p>Here's another less optimal way to get the count:</p>

        <textarea id="sample21" class="code input-xquery output-xml">count(/message[@list = "org.apache.maven.announce"])
,
xdmp:elapsed-time()</textarea>

        <p>This uses count() instead of xdmp:estimate().  Both calls use indexes, but
        count() goes one step further and checks the results by loading the documents
        off disk into memory and confirming they're a match.  This takes extra time --
        more than a second with caches cold, and 5 milliseconds with caches warm.
        This is why I showed you xdmp:estimate() in the first query, so you wouldn't
        get bored waiting for the result.  So why would anyone use count()?  It's
        useful if your query isn't fully resolvable from indexes, such as if you
        request a case-sensitive query but haven't enabled the case-sensitive index.
        But even then it's only useful against a small set of documents because of the
        disk overhead.  In normal programs count() is almost never used.</p>

        <p>Now let's make the constraints more complex.  The following query includes a
        list constraint as well as classification type constraint.  It returns the
        results as an HTML list:</p>

        <textarea id="sample22" class="code input-xquery output-xml">let $lists := ("org.apache.httpd.dev", "org.apache.httpd.users")
let $type := "announcements"
return
    &lt;ul&gt;{{
        for $m in (/message[@list = $lists][@type = $type])[1 to 10]
        return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
    }}&lt;/ul&gt;</textarea>

        <p>This query uses something new: let variable binding.  We assign $lists to a
        sequence of two strings, and $type to a single string.  Then we use those two
        variables within the XPath expression.</p>

        <p>FLWOR SYNTAX SIDEBAR: Why is there a return in the middle of a query?  Because
        it's a core part of the FLWOR (pronounced "flower") expression that drives
        much of XQuery.  The initials stand for for, let, where, order by, and return.
        FLWOR expressions let you do looping, variable assignment, conditional logic,
        sorting, and result generation.  The rule is that a FLWOR needs one or more
        "for" or "let" subclauses, in any order.  You can write just lets, just fors,
        or any combination.  These subclauses generate "tuples" (which are ordered
        sets of values, a fancy way of saying a set of variable bindings).  The tuples
        are then passed through the optional "where" clause and, if they survive, get
        sorted by the optional "order by" clause.  Finally there's a mandatory
        "return" clause that indicates what to do with each surviving tuple.  In the
        query above we bind two variables, and use a "return" to generate a new &lt;ul&gt;
        node using them.  Inside the enclosed expression we use a "for" to iterate and
        a "return" to generate a new node.  The key thing to remember is that a
        "return" doesn't return control to the caller like in a procedural language.
        It's behaves more like a "do".  Why didn't the W3C in defining XQuery name it
        "do"?  Who would want to use FLWOD expressions?</p>

        <p>Let's check how fast this query operates.  We can test the raw
        index-resolution performance with this simplified query:</p>

        <textarea id="sample23" class="code input-xquery output-xml">let $lists := ("org.apache.httpd.dev", "org.apache.httpd.users")
let $type := "announcements"
return xdmp:estimate(/message[@list = $lists][@type = $type])
,
xdmp:elapsed-time()</textarea>

        <p>I see a time of 0.2 milliseconds.</p>

        <p>Searching attachments is a key requirement for robust email searching.  In our
        XML model, attachments are represented by &lt;attachment&gt; elements.  The
        following query shows one at random:</p>

        <textarea id="sample24" class="code input-xquery output-xml">(/message//attachment)[1]</textarea>

        <p>Each attachment element uses attributes to hold various metadata fields, and
        stores the attachment's content details within.  The above attachment happens
        to be a patch file.  It might be more interesting to find a PowerPoint
        attachment, so let's find some using the @extension attribute.</p>

        <textarea id="sample25" class="code input-xquery output-xml">(/message//attachment[@extension = "ppt"])[1]</textarea>

        <p>That's more interesting, and it reveals a bit about how MarkMail handles
        Office attachments.  They're stored raw as a binary document (linked to from
        the file attribute).  They're also stored in a converted-to-PDF format (linked
        to from the &lt;attachment-pdf&gt; child element).  From the PDF there's a binary
        screen-shot image taken on every page, in both large and thumbnail formats
        (linked to with yet more child elements).  The main XML document maintains
        links to all the separate binary documents.  The XML also tracks, internally,
        what text resides on every page of the attachment.  This lets MarkMail search
        inside attachments and know which pages have the hits.</p>

        <p>You might be wondering where attachments fit into the message structure.  We
        can find out.  We just need to write a query for messages having an
        attachment.  The following query does that by finding a PowerPoint attachment
        element, then asking for its root element:</p>

        <textarea id="sample26" class="code input-xquery output-xml">root((/message//attachment[@extension = "ppt"])[1])</textarea>

        <p>Someone more familiar with XPath would write this (the dot is important; it
        roots the internal path to the message not the whole database):</p>

        <textarea id="sample27" class="code input-xquery output-xml">(/message[.//attachment/@extension = "ppt"])[1]</textarea>

        <p>Someone exercising their FLWOR skills would write this:</p>

        <textarea id="sample28" class="code input-xquery output-xml">(
    for $m in /message
    where $m//attachment/@extension = "ppt"
    return $m
)[1]</textarea>

        <p>They all get the job done.</p>
    </div>,
    (), 6
)

