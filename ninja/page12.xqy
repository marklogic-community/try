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
        <h1>The Search API</h1>

        <p>The Search API provides conveniences on top of the lower-level cts:query
        underpinnings.  It can parse a user's typed query, execute the corresponding
        search, return highlighted results, and return facet values.  It has numerous
        extension points where you can still drop down to the cts:query layer.</p>

        <p>The Search API lets you control the syntax of user query strings, but out of
        the box it supports simple words or quoted phrases, like this:</p>

        <p><span class="example">semi-conductor "moore's law"</span></p>

        <p>It supports constraints on where in a document to match:</p>

        <p><span class="example">list:apache from:ibm.com subject:release "proud to announce"</span></p>

        <p>Along with negation:</p>

        <p><span class="example">list:apache -list:tomcat</span></p>

        <p>As well as things like boolean grouping:</p>

        <p><span class="example">(cat OR dog) AND horse</span></p>

        <p>As a programmer it's easy to construct queries like these using cts:query
        objects, and you've seen it done above.  But it can take some work to parse
        the user's string and construct the cts:query objects.  That's a core feature
        of the Search API.</p>

        <p>The Search API is provided along with MarkLogic Server but because it's
        written in XQuery, you need to import it like any other module.  Try this
        query:</p>

        <textarea id="sample45" class="trymlcode input-xquery output-xml">import module namespace search =
	"http://marklogic.com/appservices/search" at
	"/MarkLogic/appservices/search/search.xqy";
search:search("hello world")</textarea>

        <p>What you see is an XML summary of the results.  It tells you which documents
        matched, and with what score.  It includes by default a short snippet showing
        some text around the match with hits highlighted.  Handy!</p>

        <p>You can control the search:search() behavior to give it extra capabilities or
        specify preferences by passing in an options node (or configuring an options
        node in your configuration).  The below example specifies three new
        constraints: "list", "from", and "subject".</p>

        <textarea id="sample46" class="trymlcode input-xquery output-xml">import module namespace search =
	"http://marklogic.com/appservices/search" at
	"/MarkLogic/appservices/search/search.xqy";

search:search("list:apache from:ibm.com subject:release patches",
  &lt;options xmlns="http://marklogic.com/appservices/search"&gt;
    &lt;constraint name="list"&gt;
      &lt;word&gt;
        &lt;element ns="" name="message"/&gt;
        &lt;attribute ns="" name="list"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="from"&gt;
      &lt;word&gt;
        &lt;element ns="" name="from"/&gt;
        &lt;attribute ns="" name="address"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="subject"&gt;
      &lt;word&gt;
        &lt;element ns="" name="subject"/&gt;
        &lt;attribute ns="" name="normal"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
  &lt;/options&gt;)</textarea>

        <p>If you change search:search() to search:parse() and you'll see the underlying
        cts:query that's being executed.  Give it a try.  You'll notice the result is
        XML.  Every cts:query construct has an XML serialization and that's what
        you're seeing here (with a few extra notations from the Search API).</p>

        <p>Results are sorted by relevance score.  Often that's appropriate, but
        sometimes a user might want to sort by date.  We can offer that option via the
        options node.  The following lets the user sort by "relevance",
        "date-forward", or "date-backward".  If sorting by date, relevance score
        breaks any ties.</p>

        <textarea id="sample47" class="trymlcode input-xquery output-xml">import module namespace search =
	"http://marklogic.com/appservices/search" at
	"/MarkLogic/appservices/search/search.xqy";

search:search("list:hadoop bug sort:date-forward",
  &lt;options xmlns="http://marklogic.com/appservices/search"&gt;
    &lt;constraint name="list"&gt;
      &lt;word&gt;
        &lt;element ns="" name="message"/&gt;
        &lt;attribute ns="" name="list"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="from"&gt;
      &lt;word&gt;
        &lt;element ns="" name="from"/&gt;
        &lt;attribute ns="" name="address"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="subject"&gt;
      &lt;word&gt;
        &lt;element ns="" name="subject"/&gt;
        &lt;attribute ns="" name="normal"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;

    &lt;operator name="sort"&gt;
      &lt;state name="relevance"&gt;
        &lt;sort-order&gt;
          &lt;score/&gt;
        &lt;/sort-order&gt;
      &lt;/state&gt;
      &lt;state name="date-forward"&gt;
        &lt;sort-order direction="ascending" type="xs:dateTime"&gt;
          &lt;element ns="" name="message"/&gt;
          &lt;attribute ns="" name="date"/&gt;
        &lt;/sort-order&gt;
        &lt;sort-order&gt;
          &lt;score/&gt;
        &lt;/sort-order&gt;
      &lt;/state&gt;
      &lt;state name="date-backward"&gt;
        &lt;sort-order direction="descending" type="xs:dateTime"&gt;
          &lt;element ns="" name="message"/&gt;
          &lt;attribute ns="" name="date"/&gt;
        &lt;/sort-order&gt;
        &lt;sort-order&gt;
          &lt;score/&gt;
        &lt;/sort-order&gt;
      &lt;/state&gt;
    &lt;/operator&gt;

  &lt;/options&gt;)</textarea>

        <p>You'll need to specify a range index for the QName being sorted, in order to
        make the sort efficient.  We have pre-configured such an index on
        message/@date so the above should work just fine for you.</p>

        <p>Using our message/@date range index we can also let the user query against
        specific date ranges.  Here's an example that demonstrates constraining by
        pre-defined by dynamically-calculated named date ranges: today, yesterday,
        30-days, 60-days, year, and decade.  Because mail on our site here isn't
        constantly updating, we'll search for date:decade to match all mails in the
        last 10 years that include the phrase "web server".</p>

        <textarea id="sample48" class="trymlcode input-xquery output-xml">import module namespace search =
  "http://marklogic.com/appservices/search"
  at "/MarkLogic/appservices/search/search.xqy";

search:search('"web server" date:decade',
&lt;options xmlns="http://marklogic.com/appservices/search"&gt;
  &lt;constraint name="date"&gt;
    &lt;range type="xs:dateTime"&gt;
      &lt;element ns="" name="message"/&gt;
      &lt;attribute ns="" name="date"/&gt;
      &lt;computed-bucket name="today" ge="P0D" lt="P1D"
           anchor="start-of-day"&gt;Today&lt;/computed-bucket&gt;
      &lt;computed-bucket name="yesterday" ge="-P1D" lt="P0D"
           anchor="start-of-day"&gt;yesterday&lt;/computed-bucket&gt;
      &lt;computed-bucket name="30-days" ge="-P30D" lt="P0D"
           anchor="start-of-day"&gt;Last 30 days&lt;/computed-bucket&gt;
      &lt;computed-bucket name="60-days" ge="-P60D" lt="P0D"
           anchor="start-of-day"&gt;Last 60 Days&lt;/computed-bucket&gt;
      &lt;computed-bucket name="year" ge="-P1Y" lt="P0D"
           anchor="now"&gt;Last Year&lt;/computed-bucket&gt;
      &lt;computed-bucket name="decade" ge="-P10Y" lt="P0D"
           anchor="now"&gt;Last Decade&lt;/computed-bucket&gt;
    &lt;/range&gt;
  &lt;/constraint&gt;
&lt;/options&gt;)</textarea>

        <p>In the resulting XML, look what comes after the document results.  There's a
        &lt;search:facet name="date"&gt; section.  That's automatically added when you have
        a range constraint.  It lists how many matches there are to the query in each
        range bucket.  You can use it to present a sidebar offering the user the
        ability to click on a facet to isolate the search to just documents matching
        that facet value, like how MarkMail lets you slide over the date histogram.</p>

        <p>Just be mindful of performance.  The &lt;search:metrics&gt; element shows you how
        much time was taken doing the facet work.  If you're not interested in the
        facets, you can add &lt;return-facets&gt;false&lt;/return-facets&gt;.  If you only want
        facets and not results, you can use &lt;return-results&gt;false&lt;/return-results&gt;.</p>

        <p>You don't always need buckets for facets.  Here's how to extract the top 100
        senders (without results):</p>

        <textarea id="sample49" class="trymlcode input-xquery output-xml">import module namespace search =
	"http://marklogic.com/appservices/search" at
	"/MarkLogic/appservices/search/search.xqy";

search:search("list:hadoop bug",
  &lt;options xmlns="http://marklogic.com/appservices/search"&gt;
    &lt;constraint name="list"&gt;
      &lt;word&gt;
        &lt;element ns="" name="message"/&gt;
        &lt;attribute ns="" name="list"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="from"&gt;
      &lt;word&gt;
        &lt;element ns="" name="from"/&gt;
        &lt;attribute ns="" name="address"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;
    &lt;constraint name="subject"&gt;
      &lt;word&gt;
        &lt;element ns="" name="subject"/&gt;
        &lt;attribute ns="" name="normal"/&gt;
      &lt;/word&gt;
    &lt;/constraint&gt;

    &lt;constraint name="sender"&gt;
      &lt;range type="xs:string" facet="true"&gt;
        &lt;element ns="" name="from"/&gt;
        &lt;attribute ns="" name="personal"/&gt;
        &lt;facet-option&gt;frequency-order&lt;/facet-option&gt;
        &lt;facet-option&gt;limit=100&lt;/facet-option&gt;
      &lt;/range&gt;
    &lt;/constraint&gt;

    &lt;return-results&gt;false&lt;/return-results&gt;
  &lt;/options&gt;)</textarea>
    </div>,
    (), 12
)
