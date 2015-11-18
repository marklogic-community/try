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
        <h1>Extending Search API</h1>

        <p>There's much more to the Search API, and you can extend it yourself by writing
        custom constraints.  Custom constraints are useful if you want full control
        over how a term without a constraint prefix should be handled, want to provide
        relevance weightings to different constraints, want a constraint to look in
        multiple places for a match, or want features like implicit phrase boosting.
        Let's look at how we'd control a term without a constraint prefix.</p>

        <p>By default, terms entered into search:search() simply search all text nodes of
        a document.  If we want to control that behavior we can plug in a little
        code.  The following options node says for regular terms to call out to our
        own search-options.xqy library module to control the behavior.  In it we
        specify exactly where we want to look (i.e. not inside header values) and with
        what relevance weightings.</p>

        <textarea id="sample50" class="trymlcode input-xquery output-xml">search:search("hello world",
  &lt;options xmlns="http://marklogic.com/appservices/search"&gt;
    &lt;term apply="myterm" ns="http://try.marklogic.com/search-options"
                         at="/lib/search-options.xqy"&gt;
      &lt;empty apply="all-results"/&gt;
    &lt;/term&gt;
  &lt;/options&gt;)</textarea>

        <p>The search-options.xqy library is fairly complex, but it's a lot of
        boilerplate.  The so:myterm() function extracts the simple token and converts
        it to a complex cts:or-query.  It makes sure to use the options passed in on
        the options node for things like case sensitivity.  The important part of this
        is the cts:or-query definition that dictates where to look for matches and
        with what relevance weightings.</p>

        <textarea id="sample51" class="trymlcode input-xquery output-xml">xquery version "1.0-ml";

module namespace so="http://try.marklogic.com/search-options";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

import module namespace searchdev =
  "http://marklogic.com/appservices/search/searchdev"
  at "/MarkLogic/appservices/search/custom-parse.xqy";

declare namespace opt = "http://marklogic.com/appservices/search";

declare function so:term-option-to-search-option($opts as element()?)
as element()*
{{
    for $opt in $opts/opt:term-option
    where not(starts-with($opt, "lang="))
    return &lt;cts:option&gt;{{$opt/string()}}&lt;/cts:option&gt;
}};

declare function so:myterm($ps as map:map, $term-elem as element()?)
as schema-element(cts:query)
{{
  (
  let $token := searchdev:current($ps)
  let $options := so:term-option-to-search-option($term-elem)
  return
  &lt;cts:or-query qtextconst="{{ $token }}"&gt;
    {{ cts:element-attribute-word-query(xs:QName("message"),
         xs:QName("list"), string($token), $options, 2.5) }}
    {{ cts:element-attribute-word-query(xs:QName("attachment"),
         xs:QName("file"), string($token), $options, 3) }}
    {{ cts:element-attribute-word-query(xs:QName("from"),
         xs:QName("personal"), string($token), $options, 3) }}
    {{ cts:element-attribute-word-query(xs:QName("from"),
         xs:QName("address"), string($token), $options, 3) }}
    {{ cts:element-word-query(xs:QName("subject"), string($token),
         $options, 2) }}
    {{ cts:element-word-query(xs:QName("para"), string($token),
         $options, 1) }}
    {{ cts:element-word-query(xs:QName("attachpara"), string($token),
         $options, 0.75) }}
    {{ cts:element-word-query(xs:QName("quotepara"), string($token),
         $options, 0.5) }}
  &lt;/cts:or-query&gt;
  ,
  searchdev:advance($ps)
  )
}};</textarea>

        <p>I've installed the library for you.  You can't modify it, but you can tweak
        the search:search() call.</p>
    </div>,
    (), 13
)
