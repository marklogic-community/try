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
        <h1>Text Search</h1>

        <p>All the examples above show MarkLogic Server acting like a database: A
        database of documents, sure, but still just doing the core job of matching,
        retrieving, sorting, and counting.  MarkLogic can also act like a search
        engine, with rich support for human language and the unique challenges
        involved in written text.  This section digs into those features.</p>

        <p>Let me start with a question: Should a query for "hello world" match a
        document containing the text "Hello, Worlds!".  Maybe, but maybe not.  The
        capitalization is different, the punctuation is different, and while one is
        singular the other is plural.  Close enough?  MarkLogic gives you as the
        programmer the ability to decide, with flags to control case-sensitivity,
        punctuation-sensitivity, diacritic-sensitivity, stemming, and thesaurus
        expansion in matches.</p>

        <p>The basic building-block of text searches is a cts:query object.  The "cts"
        namespace stands for "core text search".  Here's a basic example:</p>

        <textarea id="sample33" class="code input-xquery output-xml">cts:search(//subject, cts:word-query("release"))[1 to 10]</textarea>

        <p>This searches for &lt;subject&gt; elements that have within them the word "release".
        The first argument to cts:search() dictates the scope of the search.  The
        second argument dictates the match constraint.  A simple cts:word-query just
        tries to match the given word (or phrase).</p>

        <p>Because you didn't specify any options, the cts:word-query uses some sensible
        defaults.  It's case-insensitive because the term was lower-case which implies
        no preference for case; had it used any capital letters the query would've
        been case-sensitive.  It also runs stemmed because we have the stemming index
        enabled and that's a good default for searching text.  Because it's
        case-insensitive and stemmed, you'll see "RELEASE" and "Released" as valid
        matches.  We can control the options with a second argument:</p>

        <textarea id="sample34" class="code input-xquery output-xml">cts:search(//subject, cts:word-query("release", "unstemmed"))[1 to 10]</textarea>

        <p>The second argument accepts a sequence of strings.  Up above we passed a
        single string.  Is that legal?  Yes, in XQuery.  In XQuery there's no
        difference between a single value and a sequenence of length one containing
        that value.  The following query passes a sequence of strings to also require
        case sensitivity in the matches:</p>

        <textarea id="sample35" class="code input-xquery output-xml">cts:search(//subject, cts:word-query("RELEASE", ("unstemmed","case-sensitive")))[1 to 10] </textarea>

        <p>That might be easier to read using a FLWOR:</p>

        <textarea id="sample36" class="code input-xquery output-xml">let $query := cts:word-query("release", ("unstemmed","case-sensitive"))
return cts:search(//subject, $query)[1 to 10]</textarea>

        <p>There's dozens of cts:query constructors.  Here's one that uses a boolean
        constructor along with some query constructors that specify in which element
        or element-attribute location the match has to be found:</p>

        <textarea id="sample37" class="code input-xquery output-xml">let $lists := ("httpd", "firefox")
let $types := ("general", "development", "users")
let $subject := "OT"
let $query :=
  cts:and-query((
    cts:element-attribute-word-query(
      xs:QName("message"), xs:QName("list"), $lists
    ),
    cts:element-attribute-value-query(
      xs:QName("message"), xs:QName("type"), $types
    ),
    cts:element-word-query(
      xs:QName("subject"), $subject
    )
  ))
return
&lt;ul&gt;{{
    for $m in cts:search(/message, $query)[1 to 10]
    return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>The $query variable is a cts:and-query object containing three other queries,
        all of which have to be satisfied for the whole cts:and-query query to be
        satisfied.  The first is a cts:element-attribute-word-query.  This says we're
        looking inside a given element-attribute for a particular word.  In this case
        "httpd" or "firefox".  We're limiting our view to lists that have those words
        in their names.  The second is a cts:element-attribute-value-query.  By
        changing "word-query" to "value-query" we're saying we're not looking for word
        containment but full value matching.  The third is a cts:element-word-query
        saying we're looking inside subject elements for the word "OT".  In
        list-parlance that means the post is knowingly Off Topic.  It's OK to search
        for 2-character words in MarkLogic.  This also shows the value of a word match
        (like a search engine), comapred to a simple character substring match (like a
        relational database).</p>

        <p>Change "OT" to any word or phrase and have fun.  For example:</p>

        <textarea id="sample38" class="code input-xquery output-xml">let $lists := ("httpd", "firefox")
let $types := ("general", "development", "users")
let $subject := ("web mail", "gmail", "yahoo mail")
let $query :=
  cts:and-query((
    cts:element-attribute-word-query(
      xs:QName("message"), xs:QName("list"), $lists
    ),
    cts:element-attribute-value-query(
      xs:QName("message"), xs:QName("type"), $types
    ),
    cts:element-word-query(
      xs:QName("subject"), $subject
    )
  ))
return
&lt;ul&gt;{{
    for $m in cts:search(/message, $query)[1 to 10]
    return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>This allows matches for any of those subjects.  In many cases in XQuery you
        can pass a single item or a sequence to a function.  With cts:query objects a
        sequence typically means to OR the options.  You can specify multiple QNames
        or multiple values by just passing sequences.</p>

    </div>,
    (), 8
)

