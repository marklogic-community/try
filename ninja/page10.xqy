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
        <h1>Functions</h1>

        <p>The XQuery language supports declaring functions and grouping them together in
        library modules.  As your code grows more complex this helps keep it
        manageable.  Here's the above query rewritten to use some local functions
        (which use the "local" namespace) to build the query piece-by-piece.  Notice
        there's typing information for variables and return values.  That's optional
        but usually a good idea.  Each type accepts a modifier the same as in regular
        expressions: asterisk means 0 to n many, question mark means 0 or 1, plus
        means 1 to n many, and no modifier means exactly one.</p>

        <textarea id="sample40" class="code input-xquery output-xml">declare function local:random-word()
as xs:string
{{
  let $words := ("release", "thank you", "function")
  let $random := 1 + xdmp:random(2)
  return $words[$random]
}}

declare function local:lists-query(
  $lists as xs:string*
) as cts:query
{{
  cts:element-attribute-word-query(
    xs:QName("message"), xs:QName("list"), $lists
  )
}};

declare function local:types-query(
  $types as xs:string*
) as cts:query
{{
  cts:element-attribute-value-query(
    xs:QName("message"), xs:QName("type"), $types
  )
}};

declare function local:word-query(
  $word as xs:string
) as cts:query
{{
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
}};

declare function local:get-query(
  $lists as xs:string*,
  $types as xs:string*,
  $word as xs:string*
) as cts:query
{{
  cts:and-query((
    local:lists-query($lists),
    local:types-query($types),
    local:word-query($word)
  ))
}};

let $lists := ("httpd", "firefox")
let $types := ("announcements", "general", "development")
let $word := local:random-word()
let $query := local:get-query($lists, $types, $word)
return
&lt;ul&gt;
{{
for $m in cts:search(/message, $query)[1 to 100]
return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}
&lt;/ul&gt;</textarea>

        <p>To break functions into library modules you put them in a separate file and
        give them a special header.  Here's file test-lib.xqy (which is already
        installed on the box for you):</p>

        <textarea id="sample41" class="code input-xquery output-xml">module namespace test="http://try.marklogic.com/test";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare function test:median(
  $values as xs:int*
) as xs:int
{{
  let $sorted :=
    for $value in $values
    order by $value
    return $value
  let $midpoint := count($sorted) idiv 2
  return $sorted[$midpoint + 1]
}};</textarea>

And here's how you import the library and use it:

<textarea id="sample42" class="code input-xquery output-xml">import module namespace test = "http://try.marklogic.com/test" at "/lib/test-lib.xqy";

let $values := (7,4,2,3,1,6,5)
return test:median($values)</textarea>
    </div>,
    (), 10
)

