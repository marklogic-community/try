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
        <p>We assume you know the basics.  If you're truly brand new, you should probably
        jump out and find some introductory material, then come back.</p>

        <p>All the sample code you'll see is <em>live</em> and you're invited to execute
        it as we go along.  You can (and should) tweak it with your own changes.  For
        a test data set, we've loaded roughly 5,000,000 emails that were copied over
        from the <a href="http://markmail.org">MarkMail.org site</a>.  Each email is represented by an XML document, and
        for mails that have attachments they're held in separate binary documents
        within the database with links in the main XML document.</p>

        <p>We've placed the data on a single shared RackSpace virtualized machine.  We're
        using security rules so you (as a public user) can read, but not write, to the
        database, and each query is allowed a maximum of 10 seconds to complete before
        it's forcibly killed.</p>

        <p>Here's some API documentation you might want to refer to as you follow along:</p>
        <ul>
            <li><a href="http://developer.marklogic.com/pubs/4.2/apidocs/All.html">Function reference</a></li>
            <li><a href="http://docs.marklogic.com/">Searchable documentation</a></li>
        </ul>
    </div>,
    (
        <h1>Welcome to the MarkLogic Server online playground!</h1>,
        <p class="teaser">This tutorial gets you started writing queries against MarkLogic Server.
        We'll begin with some simple one-liner queries, progress to some modular
        programs, and along the way explore how to use XPath, XQuery, and MarkLogic's
        Search API.</p>
    ),
    1
)
