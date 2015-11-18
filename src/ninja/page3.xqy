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

import module namespace template="http://try.marklogic.com/template" at "../lib/template.xqy";

template:apply(
    <div>
        <h1>Looking at a Mail Message</h1>

        <p>Take a minute to look at the XML format returned by the above query.  It's the
        genuine internal document format used by MarkMail to represent emails.  You
        may be thinking, hey, emails aren't usually written in the XML format.  That's
        right, they're usually sent over the wire in a format known as RFC 822, and
        persisted on disk in a variety of formats like mbox, maildir, or PST.
        MarkMail reads email in these various formats and converts them into this
        singular XML model.</p>

        <p>The &lt;message&gt; root element has several attributes that provide metadata about
        the email: its list, date, MarkMail id, mail message id, etc.  Below that are
        all the various mail headers are gathered under a &lt;headers&gt; element.  A
        handful of important headers (from, to, cc, subject) have attributes on them
        which hold strings extracted from the raw header value.</p>

        <p>The &lt;body&gt; element holds the actual text.  Each paragraph gets its own &lt;para&gt;
        element, including a quote depth.  The initial greeting and footer (if any)
        are detected during the load and identified with corresponding elements, which
        makes it easy to exclude them from searches.  Any email addresses and URLs in
        the body are tagged.  That way, during display, the emails can be obfuscated
        and URLs rendered as hyperlinks.  (You can see we obfuscated the email
        addresses in the source here so spammers can't use this site to gather
        addresses.  In the real MarkMail database the emails are unobfuscated in the
        source but obfuscated on display and revealed only after the user solves a
        CAPTCHA.  That's the only change between this data and the live site.)</p>

        <p>What's most interesting about this data model is how simple it is.  It enables
        a robust, feature-rich site but the model fits on the back of a napkin.  An
        email is one logical item, represented by one physical item in the database.
        Try to imagine how you'd model, retrieve, and query this kind of textual,
        hierarchical, irregular data using the relational model.</p>

        <p>In the above query we gave you a document identifier to use.  If we weren't
        around giving you ids, what would you do?  Well, you might just ask for a
        message at random.  Here's how you do that:</p>

        <textarea id="sample5" class="trymlcode input-xquery output-xml">(doc()/message)[1]</textarea>

        <p>This query returns the first document in the database (order is essentially
        random, though it is stable and doesn't change between executions).  The first
        message happens to be written in Russian.  That's fine; MarkLogic supports
        storage and searching of all languages whose text can be represented in XML,
        and provides advanced support (tokenization, stemming, and collation) for more
        than a dozen languages, including Russian.</p>

        <p>If you look at the message's "id" attribute and do some copy/paste work you
        can derive a URL to see this mail on MarkMail.  In fact, here's a query to
        generate that link for you:</p>

        <textarea id="sample6" class="trymlcode input-xquery output-xml">concat("http://markmail.org/message/", (doc()/message/@id)[1])</textarea>

        <p>Pro tip: You can drop the leading doc() and you get the same result.  Any
        rooted XPath is assumed to query across all documents.  Let's use that
        shortcut and ask for ten random emails to explore:</p>

        <textarea id="sample7" class="trymlcode input-xquery output-xml">(/message)[1 to 10]</textarea>
    </div>,
    (), 3
)

