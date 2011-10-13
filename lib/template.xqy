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
		$content as element()*,
        $headerContent as element()*,
        $page as xs:integer
) as item()+
{
	let $set := xdmp:set-response-content-type("text/html; charset=utf-8")
    let $nav := (
        <li><h4><a href="./index.xqy">Getting Started</a></h4></li>,
        <li><h4><a href="./page2.xqy">Lay of the Land</a></h4></li>,
        <li><h4><a href="./page3.xqy">Looking at a Mail Message</a></h4></li>,
        <li><h4><a href="./page4.xqy">Drilling in with XPath</a></h4></li>,
        <li><h4><a href="./page5.xqy">Formatting Results</a></h4></li>,
        <li><h4><a href="./page6.xqy">Constraints</a></h4></li>,
        <li><h4><a href="./page7.xqy">Facets</a></h4></li>,
        <li><h4><a href="./page8.xqy">Text Search</a></h4></li>,
        <li><h4><a href="./page9.xqy">Search Relevance</a></h4></li>,
        <li><h4><a href="./page10.xqy">Functions</a></h4></li>,
        <li><h4><a href="./page11.xqy">Query-Limited Facets</a></h4></li>,
        <li><h4><a href="./page12.xqy">The Search API</a></h4></li>,
        <li><h4><a href="./page13.xqy">Extending Search API</a></h4></li>,
        <li><h4><a href="./page14.xqy">Conclusion</a></h4></li>
    )
	return (
"<!DOCTYPE html>",
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>{ string($nav[$page]/h4/a) } - Try MarkLogic</title>
        <!--[if IE]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
        <style>
            article, aside, dialog, figure, footer, header, hgroup, menu, nav, section {{ display: block; }}
        </style>
        <link rel="shortcut icon" href="favicon.ico" />

        <link rel="stylesheet" href="/css/screen.css" type="text/css" media="screen, projection" />
        <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>

        <link rel="stylesheet" href="http://try.marklogic.com:8005/css/tryml.css" type="text/css" media="screen, projection" />
        <!--[if lt IE 8]><link rel="stylesheet" href="/css/ie.css" type="text/css" media="screen, projection"/><![endif]-->
    </head>
    <body>
        <div class="header">
            <div class="top_bar">
                <div class="container">
                    <a id="logo" href="/"><img alt="MarkLogic" src="../img/ml_logo.png"/></a>
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
                <div class="content">
                    { $content }
                    <div class="pagination">{
                        if($page > 1)
                        then <p class="pagination_prev"><a href="{ $nav[$page - 1]/h4/a/@href }" class="btn btn_blue">&laquo; Previous</a><span>{ string($nav[$page - 1]/h4/a) }</span></p>
                        else (),
                        if($page < count($nav))
                        then <p class="pagination_next"><a href="{ $nav[$page + 1]/h4/a/@href }" class="btn btn_blue">Next &raquo;</a><span>{ string($nav[$page + 1]/h4/a) }</span></p>
                        else ()
                    }</div>
                </div>
            </div>
        </div>

        <div class="footer">
            <div class="container">
                <p>Copyright © 2010-2011 MarkLogic Corporation. All rights reserved. | Powered by MarkLogic Server 4.2-4.</p>
            </div>
        </div>
    </body>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"><!-- --></script>
    <script src="http://try.marklogic.com:8005/js/tryml.js" type="text/javascript"><!-- --></script>
</html>
)
};
