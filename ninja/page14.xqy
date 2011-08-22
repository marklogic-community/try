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
        <h1>Conclusion</h1>

        <p>OK, still with me?  Impressive!  I hope this has given you an understanding of
        how XPath, XQuery, and the Search API work to query MarkLogic Server.  If
        you're interested in understanding more about indexing models and internals,
        let me suggest you read:</p>

        <a href="http://developer.marklogic.com/inside-marklogic">"Inside MarkLogic Server"</a>, a long-form paper describing the MarkLogic Server
          internals: its data model, indexing system, update model, and operational
          behaviors.
    </div>,
    (), 14
)
