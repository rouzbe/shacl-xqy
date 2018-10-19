module namespace shacl-xqy = "shacl-xqy";

import module namespace shacl-apply = "shacl-apply"
    at "apply.xqy";

declare variable $shacl-apply := xdmp:function(xs:QName('shacl-apply:apply'));

declare function shacl-xqy:sparql($query as xs:string) as item()* {
  shacl-xqy:sparql($query, map:new(), (), ())
};

declare function shacl-xqy:sparql($query as xs:string, $bindings as map:map) as item()* {
  shacl-xqy:sparql($query, $bindings, true())
};

declare function shacl-xqy:sparql(
  $query as xs:string,
  $bindings as map:map,
  $resolveFunctions as xs:boolean?,
  $options as xs:string*,
  $store as sem:store*) as item()* {

  let $query :=
    if ($resolveFunctions = true()) then (
      "PREFIX xdmp: <http://marklogic.com/xdmp#> " ||
      shacl-apply:resolveFunctions($query),
      map:put($bindings, "shapply", $shacl-apply)
    )
    else
      $query

  return
    try {
      sem:sparql($query, $bindings, $options, $store)
    } catch ($e) {
      xdmp:log(($query, $bindings, $resolveFunctions, $e))
    }
};
