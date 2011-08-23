xquery version "1.0-ml";

module namespace so="http://try.marklogic.com/search-options";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

import module namespace searchdev = "http://marklogic.com/appservices/search/searchdev"
  at "/MarkLogic/appservices/search/custom-parse.xqy";

declare namespace opt = "http://marklogic.com/appservices/search";

declare function so:term-option-to-search-option($opts as element()?)
as element()*
{
    for $opt in $opts/opt:term-option
    where not(starts-with($opt, "lang="))
    return <cts:option>{$opt/string()}</cts:option>
};


declare function so:myterm($ps as map:map, $term-elem as element()?)
as schema-element(cts:query) 
{
    (
    let $token := searchdev:current($ps)
    let $options := so:term-option-to-search-option($term-elem)
    return
    <cts:or-query qtextref="cts:annotation" qtextconst="{ $token }">
      { cts:element-attribute-word-query(xs:QName("message"), xs:QName("list"), string($token), $options, 2.5) }
      { cts:element-attribute-word-query(xs:QName("attachment"), xs:QName("file"), string($token), $options, 3) }
      { cts:element-attribute-word-query(xs:QName("from"), xs:QName("personal"), string($token), $options, 3) }
      { cts:element-attribute-word-query(xs:QName("from"), xs:QName("address"), string($token), $options, 3) }
      { cts:element-word-query(xs:QName("subject"), string($token), $options, 2) }
      { cts:element-word-query(xs:QName("para"), string($token), $options, 1) }
      { cts:element-word-query(xs:QName("attachpara"), string($token), $options, 0.75) }
      { cts:element-word-query(xs:QName("quotepara"), string($token), $options, 0.5) }
    </cts:or-query>
    ,
    searchdev:advance($ps)
    )
};

declare function so:mytermXXX($ps as map:map, $term-elem as element()?)
as schema-element(cts:query) 
{
    (
    let $token := string(searchdev:current($ps))
    let $options := so:term-option-to-search-option($term-elem)
    return
    <cts:or-query qtextconst="{ $token }">
      <cts:element-attribute-word-query weight="2.5" qtextconst="{ $token }">
        <cts:element>message</cts:element>
        <cts:attribute>list</cts:attribute>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-attribute-word-query>
      <cts:element-attribute-word-query weight="3" qtextconst="{ $token }">
        <cts:element>attachment</cts:element>
        <cts:attribute>file</cts:attribute>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-attribute-word-query>
      <cts:element-attribute-word-query weight="3" qtextconst="{ $token }">
        <cts:element>from</cts:element>
        <cts:attribute>personal</cts:attribute>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-attribute-word-query>
      <cts:element-attribute-word-query weight="3" qtextconst="{ $token }">
        <cts:element>from</cts:element>
        <cts:attribute>address</cts:attribute>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-attribute-word-query>
      <cts:element-word-query weight="2" qtextconst="{ $token }">
        <cts:element>subject</cts:element>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-word-query>
      <cts:element-word-query qtextconst="{ $token }">
        <cts:element>para</cts:element>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-word-query>
      <cts:element-word-query weight="0.75" qtextconst="{ $token }">
        <cts:element>attachpara</cts:element>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-word-query>
      <cts:element-word-query weight="0.5" qtextconst="{ $token }">
        <cts:element>quotepara</cts:element>
        <cts:text xml:lang="en">{ $token }</cts:text>
      </cts:element-word-query>
    </cts:or-query>
    ,
    searchdev:advance($ps)
    )
};

