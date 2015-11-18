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

import module namespace json="http://marklogic.com/json" at "/lib/json.xqy";

let $set := xdmp:set-response-content-type("text/plain")
let $code := xdmp:get-request-field("code", "()")[1]
let $format := xdmp:get-request-field("format", "xquery")[1]
let $callback := xdmp:get-request-field("callback")[1]
let $code :=
  if ($format = "xquery") then
    concat("declare boundary-space preserve; ", $code)
  else
    $code

let $results :=
  try {
    json:object((
      "results",
      if ($format = "xquery") then
        xdmp:quote(xdmp:eval($code))
      else
        xdmp:quote(xdmp:javascript-eval($code))
    ))
  }
  catch ($e) {
    json:object((
      "error", json:object((
        "message", string($e/error:format-string),
        "line", string(($e//error:frame)[1]/error:line)
      ))
    ))
  }

return
  json:serialize(json:document($results), $callback)
