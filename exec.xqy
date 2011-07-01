import module namespace json="http://marklogic.com/json" at "lib/json.xqy";

let $set := xdmp:set-response-content-type("text/plain")
let $code := xdmp:get-request-field("code", "()")[1]

let $results :=
    try {
        json:object((
            "results", xdmp:quote(xdmp:eval($code))
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

return json:xmlToJSON(json:document($results))
