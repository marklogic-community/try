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

module namespace template="http://try.marklogic.com/template";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare function template:apply(
		$title as xs:string,
		$content as element()*,
        $headerContent as element()*,
        $page as xs:integer
) as item()+
{
	let $set := xdmp:set-response-content-type("text/html; charset=utf-8")
    let $nav := (
        <li><h4><a href="/ninja/">Getting Started</a></h4></li>,
        <li><h4><a href="/ninja/page2.xqy">Lay Of the Land</a></h4></li>,
        <li><h4><a href="/ninja/page3.xqy">Looking at a Mail Message</a></h4></li>,
        <li><h4><a href="/ninja/page4.xqy">Drilling in with XPath</a></h4></li>,
        <li><h4><a href="/ninja/page5.xqy">Formatting Results</a></h4></li>,
        <li><h4><a href="/ninja/page6.xqy">Constraints</a></h4></li>,
        <li><h4><a href="/ninja/page7.xqy">Facets</a></h4></li>,
        <li><h4><a href="/ninja/page8.xqy">Text Search</a></h4></li>,
        <li><h4><a href="/ninja/page9.xqy">Search Relevance</a></h4></li>,
        <li><h4><a href="/ninja/page10.xqy">Functions</a></h4></li>,
        <li><h4><a href="/ninja/page11.xqy">Query-Limited Facets</a></h4></li>,
        <li><h4><a href="/ninja/page12.xqy">The Search API</a></h4></li>,
        <li><h4><a href="/ninja/page13.xqy">Extending Search API</a></h4></li>,
        <li><h4><a href="/ninja/page14.xqy">Conclusion</a></h4></li>
    )
	return (
"<!DOCTYPE html>",
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>{ $title }</title>
        <!--[if IE]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
        <style>
            article, aside, dialog, figure, footer, header, hgroup, menu, nav, section {{ display: block; }}
        </style>
        <link rel="stylesheet" href="/css/screen.css" type="text/css" media="screen, projection" />
        <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
        <!--[if lt IE 8]><link rel="stylesheet" href="/css/ie.css" type="text/css" media="screen, projection"/><![endif]-->
        <link rel="shortcut icon" href="favicon.ico" />
    </head>
    <body>
        <div class="header">
            <div class="top_bar">
                <div class="container">
                    <a id="logo" href="/"><img alt="MarkLogic" src="/img/ml_logo.png"/></a>
                </div>
            </div>
            {
            if(exists($headerContent))
            then
                <div class="container">
                    <div class="welcome">{ $headerContent }</div>
                </div>
            else ()
            }
        </div>

        <div class="main">
            <div class="container">
                <div class="aside">
                    <h3>Contents</h3>
                    <ul class="subnav">{
                        for $navItem at $pos in $nav
                        return <li>{(
                            if($pos = $page)
                            then attribute class {"subnav_item_active"}
                            else (),
                            $navItem/*
                        )}</li>
                    }</ul>
                </div>
          
                <div class="content">{ $content }</div>
            </div>
        </div>

        <div class="footer">
            <div class="container">
                <p>Copyright © 2010-2011 MarkLogic Corporation. All rights reserved. | Powered by MarkLogic Server 4.2-4.</p>
            </div>
        </div>
    </body>
    <script src="/CodeMirror/js/codemirror.js" type="text/javascript"><!-- --></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"><!-- --></script>
    <script src="/js/base.js" type="text/javascript"><!-- --></script>
</html>
)
};
