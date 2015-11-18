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
        <h1>Drilling in with XPath</h1>

        <p>Sometimes you don't want to fetch whole messages, just parts of them, and in
        those cases you can use XPath to specify what part of a message you want.  The
        following query gets the first email and returns its subject element:</p>

        <textarea id="sample8" class="trymlcode input-xquery output-xml">(/message)[1]/headers/subject</textarea>

        <p>This does the same for the first ten mails:</p>

        <textarea id="sample9" class="trymlcode input-xquery output-xml">(/message)[1 to 10]/headers/subject</textarea>

        <p>This returns the subjects as strings instead of XML elements, by executing the
        string() function on each subject:</p>

        <textarea id="sample10" class="trymlcode input-xquery output-xml">(/message)[1 to 10]/headers/subject/string()</textarea>

        <p>This returns the first (random) ten paragraphs that contain URLs:</p>

        <textarea id="sample11" class="trymlcode input-xquery output-xml">(//para[url])[1 to 10]</textarea>

        <p>The double slash means any depth under the parent is fine.  The [url]
        predicate says the &lt;para&gt; element has to have a &lt;url&gt; child.</p>

        <p>Why are we using parentheses so often?  It's good practice when extracting a
        subset of items from a sequence.  In XPath, the following query doesn't say to
        get one paragraph, it says to get all first paragraphs.  It will return about
        5,000,000 paragraphs, the first paragraphs from all emails, and take a very
        long time to execute (and yes, smiley faces are how you surround comments in
        XQuery):</p>

        <textarea id="sample12" class="trymlcode input-xquery readonly">(: Don't do it this way :)
//para[1]</textarea>

        <p>That's powerful, but when you want just one paragraph, you use parentheses.
        The following query returns the first item across all paragraphs.  It executes
        close to instantly.</p>

        <textarea id="sample13" class="trymlcode input-xquery output-xml">(//para)[1]</textarea>
    </div>,
    (), 4
)

