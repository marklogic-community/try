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
        <h1>Query-Limited Facets</h1>

        <p>Earlier we mentioned a fifth argument to cts:element-attribute-values().  The
        fifth argument is a cts:query object that limits the returned results to those
        taken from documents matching the given cts:query.  The following finds the
        top senders of mails matching a specific query.</p>

        <textarea id="sample43" class="trymlcode input-xquery output-xml">let $lists := ("httpd", "firefox")
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
for $value in
    cts:element-attribute-values(
        xs:QName("from"), xs:QName("personal"), "", "frequency-order", $query
    )[1 to 100]
return concat($value, ": ", cts:frequency($value))</textarea>

        <p>We're extracting values from the from/@personal attributes, which holds the
        human-readable names of senders.  We start at "" (the beginning), ask for
        results in frequency order (so the most common occurrances are first), and
        limit results to the $query.  We then print the value and count for the top
        100.  These are the folks from Apache and Firefox who talk a lot about
        releases.</p>

        <p>We can also extract message/@year-month and sort by value (value is the
        default) and what we'll see is a traffic-by-month report, the basis for the
        MarkMail histogram chart:</p>

        <textarea id="sample44" class="trymlcode input-xquery output-xml">cts:element-attribute-values(
    xs:QName("message"), xs:QName("year-month"), "", (), $query
)[1 to 100]</textarea>

        <p>We've now seen almost all the building blocks of MarkMail.org.  But how do we
        take the user's typed string in the search box and convert it to cts:query
        objects?  For that we can use the Search API.</p>
    </div>,
    (), 11
)
