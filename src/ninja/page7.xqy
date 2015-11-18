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
        <h1>Facets</h1>

        <p>If you want to know how many mails have a PowerPoint attachment that's pretty
        easy to write:</p>

        <textarea id="sample29" class="trymlcode input-xquery output-xml">xdmp:estimate(/message//attachment[@extension = "ppt"])</textarea>

        <p>But what if you want to know what extensions are out there, the full list that
        people have sent?  Users often like to see this in search results because it
        lets them see "facets" of their results and drill in.  Someone unfamiliar with
        MarkLogic might write this:</p>

        <textarea id="sample30" class="trymlcode input-xquery readonly">(: Don't do it this way :)
distinct-values(/message//attachment/@extension)</textarea>

        <p>It's perfectly valid code, but it operates through brute force by loading
        document after document, similar to count(), and it won't finish within the 10
        second window.  It might also return an XDMP-EXPANDEDTREECACHEFULL error which
        tells you memory has filled up while running the request.  The right solution
        isn't to grow your memory sizes, it's to take a wholly different index-based
        approach:</p>

        <textarea id="sample31" class="trymlcode input-xquery output-xml">cts:element-attribute-values(
    xs:QName("attachment"), xs:QName("extension")
)</textarea>

        <p>This uses a MarkLogic extension function.  It's a bit longer to type, but it
        returns in about 60 milliseconds.  It uses what's called an element-attribute
        range index to extract the values without touching disk (an index I've
        configured already for you).  You specify the element name and attribute name
        (as XML QNames which stands for "qualified names" which means a name plus
        optional namespace prefix) and it returns the distinct values.</p>

        <p>You can also request frequency counts and/or ask for results in frequency
        order:</p>

        <textarea id="sample32" class="trymlcode input-xquery output-xml">for $item in cts:element-attribute-values(
    xs:QName("attachment"), xs:QName("extension"), "", "frequency-order"
)
return concat($item, ": ", cts:frequency($item))</textarea>

        <p>The optional third argument given here specifies the starting position.  We
        pass "" to indicate we want to start at the beginning.  The fourth argument
        controls the execution options.  We pass "frequency-order" so more frequent
        items are returned first.  The cts:frequency() call at the end reports the
        number of documents having the given $item.</p>

        <p>There's an optional fifth argument also, not yet shown, which lets you limit
        the returned values based on documents matching a particular query constraint.
        This is how MarkMail manages the bottom left corner of its search results page
        for any query you type.  More on that in the next section.</p>
    </div>,
    (), 7
)

