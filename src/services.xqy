module namespace shacl-services = "shacl-services";

import module namespace shacl-queries = "shacl-queries"
    at "queries.xqy";
import module namespace shacl-xqy = "shacl-xqy"
    at "shacl.xqy";

declare variable $pxMap := getPrefixDeclarations();
declare variable $pxStr := getPrefixDeclarationsStr();

declare function shacl-services:getFunctionType($func as sem:iri) as sem:iri {
  sparql($shacl-queries:getFunctionType, map:new(map:entry("this", $func))) ! map:get(., "type")
};

declare function shacl-services:getSPARQLFunctionSelectQuery($func as sem:iri) as xs:string {
  sparql($shacl-queries:getSPARQLFunctionSelectQuery, map:new(map:entry("this", $func))) ! map:get(., "select")
};

declare function shacl-services:runSPARQLFunctionSelectQuery($func as sem:iri, $bindings as map:map?) {
  sparql(shacl-services:getSPARQLFunctionSelectQuery($func), $bindings) ! map:get(., "result")
};

declare function shacl-services:getFunctionParameters($func as sem:iri) {
  sparql($shacl-queries:getFunctionParameters, map:new(map:entry("this", $func)))
};

declare function shacl-services:getJSFunction($func as sem:iri) {
  sparql($shacl-queries:getJSFunction, map:new(map:entry("this", $func)))
};

declare function shacl-services:resolve-QName($qname) {
  let $resolved := sem:iri(replace($qname, ".*:", map:get($pxMap, substring-before($qname, ":"))))
  return if (empty($resolved)) then sem:iri($qname) else $resolved
};

declare function shacl-services:local-name($item as sem:iri) {
  if (fn:contains($item, "#")) then
    substring-after($item, "#")
  else
    $item
};

declare function shacl-services:prefix($item as xs:string) {
  if (fn:contains($item, ":")) then
    substring-before($item, ":")
  else
    $item
};

declare function shacl-services:namespace($item as xs:string) {
  fn:replace(map:get($shacl-services:pxMap, shacl-services:prefix($item)), '#', '')
};

declare function getPrefixDeclarations() {
  let $pxMap := map:new()
  let $_ :=
    shacl-xqy:sparql(
      $shacl-queries:px || $shacl-queries:getPrefixDeclarations,
      map:new(),
      false(),
      (), ()
    ) ! map:put($pxMap, map:get(., "prefix"), map:get(., "namespace"))
  return $pxMap
};

declare function getPrefixDeclarationsStr() {
  fn:string-join((map:keys($pxMap) ! ("PREFIX " || . || ": <" || map:get($pxMap, .) || "> ")))
};

declare function sparql($query as xs:string, $bindings as map:map) as item()* {
  shacl-xqy:sparql($shacl-queries:px || $query, $bindings)
};
