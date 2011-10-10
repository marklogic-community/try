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
        <h1>Lay of the Land</h1>

        <p>OK, let's get going.  Try this query:</p>

        <textarea id="sample1" class="trymlcode input-xquery output-xml">"hello world"</textarea>

        <p>Yep, that's the classic Hello World program written in XQuery.  It's so simple
        because XQuery is a functional language and everything is an expression.  The
        "hello world" text is a string, and that's a valid expression and thus a valid
        program.  Now try this:</p>

        <textarea id="sample2" class="trymlcode input-xquery output-xml">xdmp:estimate(doc())</textarea>

        <p>It's OK if you don't understand how it works yet.  Go ahead and run it.  You
        can't hurt anything here.  This query returns the number of documents in the
        database.  You should see a bit over 5 million.  Let's try another query:</p>

        <textarea id="sample3" class="trymlcode input-xquery output-xml">xdmp:estimate(doc()/message)</textarea>

        <p>This returns the number of documents in the database that have a &lt;message&gt;
        root element.  It's a lower number than above because it doesn't include the
        binary attachments.  If you've seen XPath before this should look fairly
        familiar.</p>

        <p>The xdmp:estimate() function is a very fast counter of things.  It's named
        "estimate" rather than "count" because it's not always 100% accurate (although
        it is fully accurate for these simple queries).  More on that later.</p>

        <p>The "xdmp" part of the function name is a namespace prefix.  All functions
        have a namespace, similar to a package name in Java.  The "xdmp" namespace
        holds some of MarkLogic's extension functions.  The default namespace prefix
        is "fn" and it can usually be omitted.  Technically doc() up there could be
        written as fn:doc() and you'd get the same result.  In fact, you might want to
        try that yourself right now.  I'll wait.</p>

        <p>The doc() function without any arguments returns all documents in the database
        (that your user is entitled to see).  You can instead pass a document's unique
        identifier as an argument and then the function returns that document.  A
        document identifier can be any string, so long as the string is a valid URI.
        Here's a call to fetch a single document:</p>

        <textarea id="sample4" class="trymlcode input-xquery output-xml">doc("/ultlr54iuhh4nutn.xml")</textarea>

        <p>With this query you can see the raw XML source behind the email visible at
        <a href="http://markmail.org/message/ultlr54iuhh4nutn">http://markmail.org/message/ultlr54iuhh4nutn.</a></p>
    </div>,
    (), 2
)

