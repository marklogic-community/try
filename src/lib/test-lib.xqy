module namespace test="http://try.marklogic.com/test";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare function test:median(
  $values as xs:int*
) as xs:int
{
  let $sorted := 
    for $value in $values
    order by $value
    return $value
  let $midpoint := count($sorted) idiv 2
  return $sorted[$midpoint + 1]
};

