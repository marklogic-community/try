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
    <div>
        <h1>Search Relevance</h1>

        <p>One of the major features you get with the search engine style features of
        MarkLogic is support for ordering results by relevance.  It's often the case
        that one result might be a better match than another, even if both satisfy the
        constraints.  Relevance is based on a complex mathematical equation that
        assigns scores to each result, with the highest score considered most
        relevant.</p>

        <p>MarkLogic can use several inputs in the process of determining relevance:
        frequency of term appearance (more appearances is more relevant), proximity of
        terms to each other (terms appearing together is more relevant), document
        position of terms (words in the title are more relevant that words in the main
        body), document length (with longer documents you expect more term
        appearances, so high counts should matter less), inherent document quality
        (some documents are more naturally important than others, like Google's
        PageRank), preciseness of term matches (an exact term match might mean more
        than a more fuzzy word match), geographic proximity (weighting items with
        points closer to a given location), and any hierarchical boolean combination
        of the above.  The programmer controls these knobs and decides which are in
        effect and with what weightings.  The end result: results in beautiful
        relevance order.</p>

        <p>Here's a query where you can see a few relevance knobs in action.  We specify
        four places to look for the match $word, with different weighting on each:</p>

        <textarea id="sample39" class="code input-xquery output-xml">let $lists := ("httpd", "firefox")
let $types := ("announcements", "general", "development")
let $word := "release"
let $query :=
  cts:and-query((
    cts:element-attribute-word-query(
      xs:QName("message"), xs:QName("list"), $lists
    ),
    cts:element-attribute-value-query(
      xs:QName("message"), xs:QName("type"), $types
    ),
    cts:or-query((
      cts:element-attribute-word-query(
        xs:QName("message"), xs:QName("list"), $word, "unstemmed", 3
      ),
      cts:element-word-query(
        xs:QName("subject"), $word, "stemmed", 2
      ),
      cts:element-word-query(
        xs:QName("para"), $word, "stemmed", 1
      ),
      cts:element-word-query(
        xs:QName("quotepara"), $word, "stemmed", 0.5
      )
    ))
  ))
return
&lt;ul&gt;{{
    for $m in cts:search(/message, $query)[1 to 100]
    return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>The $query requires the message was sent to one of the $lists, is classified
        as one of the given $types, and also the cts:or-query rule has to be true as
        well.  The cts:or-query looks for $word in four places: in the message/@list
        attribute, or inside any subject, para, or quotepara element.  If it's a list
        match, it should be unstemmed (usually proper nouns shouldn't be stemmed).  If
        it's in regular text then stemming is allowed.  Appearances of the term in the
        list name are worth triple score, in subject double score, in para regular
        score, and in quotepara half score.</p>

        <p>Besides placement weighting, documents are also implicitly weighted based on
        quality.  In MarkMail we've set it up so more recent documents have a higher
        quality.  Announcement messages also have a higher quality.  So in this "top
        100" list you'll see announcements mails tend to rise to the top.</p>

        <p>In the results you'll see "Released" a lot in the subject.  That's because we
        have a weighting that prefers matches in the subject.  You might remember we
        searched for "release" but are matching "Released" so you can see how the
        query ran case-insensitive and stemmed.</p>

        <p>Try changing "release" in the query to a phrase like "thank you" which rarely
        appears in a subject line (I'm not sure what that says about open source
        mailing lists).  You can then confirm the query prefers subject line matches
        but doesn't require them.</p>
    </div>,
    (), 9
)

