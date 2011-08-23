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
        <h1>Formatting Results</h1>

        <p>We'll soon see more examples selecting messages from MarkLogic, but first
        let's look at ways to output the results more beautifully than a straight XML
        dump.  The XQuery language provides the ability to loop over nodes and
        construct new nodes.  Here's a query that converts the previous subject list
        into an HTML list:</p>

        <textarea id="sample14" class="code input-xquery output-html">&lt;ul&gt;{{
    for $m in (/message)[1 to 10]
    return &lt;li&gt;{{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>That's a full legal XQuery program.  XQuery uses XML as a native data type and
        that makes constructing markup like this extremely easy.  The curly braces
        separate literal XML from enclosed expressions.  The for loop processes each
        message and invokes the return clause once for every message.</p>

        <p>SIDEBAR: OK, let's take a minute to talk about HTML character escaping.  When
        producing HTML output like this you normally need to worry about special
        characters, otherwise you open yourself up to cross-site scripting (XSS)
        attacks.  The XSS issue arises if, for example, there's a subject string that
        contains HTML tags.  If not properly escaped, it'll be output raw and provide
        an opportunity for a malicious user to inject their own HTML content into your
        page.  In PHP you avoid that by calling htmlspecialchars() each time you
        output any string variable into the page.  You're never allowed to forget.  So
        what do we do in XQuery?  You don't have to do anything!  The escaping happens
        automatically at the language level.  That's a perk of using a markup-aware
        language.  Try it yourself:</p>

        <textarea id="sample15" class="code input-xquery output-html">&lt;li&gt;{{ "This is &lt;a href='some link'&gt;evil&lt;/b&gt; text" }}&lt;/li&gt;</textarea>

        <p>OK, let's continue.  To get a more useful HTML list, let's include the mail's
        sender, date, and subject together.  The following prints the from/@personal
        attribute which is the extracted person's name, and it formats the date as
        year/month/day:</p>

        <textarea id="sample16" class="code input-xquery output-html">&lt;ul&gt;{{
    for $m in (/message)[1 to 10]
    return &lt;li&gt;{{ $m/headers/from/@personal/string() }} on
               {{ format-dateTime($m/@date, "[Y]/[M01]/[D01]") }} wrote
               {{ $m/headers/subject/string() }}&lt;/li&gt;
}}&lt;/ul&gt;</textarea>

        <p>If we'd rather generate the result as custom XML, that's real easy:</p>

        <textarea id="sample17" class="code input-xquery output-xml">&lt;result&gt;{{
    for $m in (/message)[1 to 10]
    return
    &lt;item&gt;
      &lt;sender&gt;{{ $m/headers/from/@personal/string() }}&lt;/sender&gt;
      &lt;date&gt;{{ format-dateTime($m/@date, "[Y]/[M01]/[D01]") }}&lt;/date&gt;
      &lt;subject&gt;{{ $m/headers/subject/string() }}&lt;/subject&gt;
    &lt;/item&gt;
}}&lt;/result&gt;</textarea>

        <p>Or, if we'd rather send this to a recipient like a JavaScript program that
        prefers JSON, we can do that too, using a json.xqy library whose functions we
        import (see https://github.com/marklogic/mljson for more about the library).</p>

        <textarea id="sample18" class="code input-xquery output-javascript">import module namespace json = "http://marklogic.com/json" at "/lib/json.xqy";

json:serialize(
    json:array(
        for $m in (/message)[1 to 10]
        return json:object((
            "sender", $m/headers/from/@personal/string(),
            "date", format-dateTime($m/@date, "[Y]/[M01]/[D01]"),
            "subject", $m/headers/subject/string()
        ))
    )
)</textarea>
    </div>,
    (), 5
)

