module namespace shacl-apply = "shacl-apply";
declare namespace e = 'shacl-apply-eval';

import module namespace shacl-services = "shacl-services"
    at "services.xqy";

declare function shacl-apply:apply($func) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ())
};

declare function shacl-apply:apply($func, $param-1 as item()) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ($param-1))
};

declare function shacl-apply:apply($func, $param-1 as item(), $param-2 as item()) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ($param-1, $param-2))
};

declare function shacl-apply:apply($func, $param-1 as item(), $param-2 as item(), $param-3 as item()) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ($param-1, $param-2, $param-3))
};

declare function shacl-apply:apply($func, $param-1 as item(), $param-2 as item(), $param-3 as item(), $param-4 as item()) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ($param-1, $param-2, $param-3, $param-4))
};

declare function shacl-apply:apply($func, $param-1 as item(), $param-2 as item(), $param-3 as item(), $param-4 as item(), $param-5 as item()) {
  shacl-apply:runFunction(shacl-services:resolve-QName($func), ($param-1, $param-2, $param-3, $param-4, $param-5))
};

declare function shacl-apply:runFunction($func as sem:iri, $args as item()*) {
  let $funcType := shacl-services:local-name(shacl-services:getFunctionType($func)) return
  switch($funcType)
    case "SPARQLFunction" return
      let $bindings := map:new()
      let $_ :=
        for $binding at $index in shacl-services:getFunctionParameters($func) return
          map:put($bindings, shacl-services:local-name(map:get($binding, "path")), convert-type($args[$index], map:get($binding, "hasClass"), map:get($binding, "datatype")))
      return shacl-services:runSPARQLFunctionSelectQuery($func, $bindings)

    case "XQueryFunction"
    case "JSFunction" return
      let $jsFunc := shacl-services:getJSFunction($func)
      let $jsFuncName := map:get($jsFunc, "jsFunctionName")
      let $jsFuncLibrary := map:get($jsFunc, "jsLibraryURL")
      return eval($funcType, $jsFuncName, $jsFuncLibrary, $args)

    default return
      ("Error! " || shacl-services:local-name(shacl-services:getFunctionType($func)) || " not supported.")
};

declare function convert-type($data, $hasClass, $datatype) {
  if (fn:empty($hasClass) or $hasClass eq false()) then
    convert-to-datatype($data, $datatype)
  else
    sem:iri($data)
};

declare function convert-to-datatype($data, $datatype) {
  switch(shacl-services:local-name($datatype))
    case "boolean"
      return xs:boolean($data)
    case "int"
      return xs:int($data)
    case "integer"
      return xs:integer($data)
    case "long"
      return xs:long($data)
    case "float"
      return xs:float($data)
    case "decimal"
      return xs:decimal($data)
    case "double"
      return xs:double($data)
    case "dateTime"
      return xs:dateTime($data)
    case "date"
      return xs:date($data)
    case "time"
      return xs:time($data)
    default
      return xs:string($data)
};

declare function eval($funcType as xs:string, $jsFuncName as xs:string, $jsFuncLibrary as xs:string, $args as item()*) {
  let $nsimport :=
    if ($funcType eq "XQueryFunction") then
      "import module namespace " || shacl-services:prefix($jsFuncName) || " = '" ||
          shacl-services:namespace($jsFuncName) || "'
          at '" || $jsFuncLibrary || "';"
    else
      ()

  let $e := $nsimport || "
    declare variable $jsFuncName as xs:string external;
    declare variable $jsFuncLibrary as xs:string external;
    declare variable $args as item()* external;

    switch (fn:count($args))
      case 0 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)()
      case 1 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)($args[1])
      case 2 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)($args[1], $args[2])
      case 3 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)($args[1], $args[2], $args[3])
      case 4 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)($args[1], $args[2], $args[3], $args[4])
      case 5 return xdmp:function(xs:QName($jsFuncName), $jsFuncLibrary)($args[1], $args[2], $args[3], $args[4], $args[5])
      default return 'Error! Cannot pass more than 5 args to a function.'
  "
  let $vars as map:map := map:new((map:entry("jsFuncName", $jsFuncName), map:entry("jsFuncLibrary", $jsFuncLibrary), map:entry("args", $args)))

  return xdmp:eval($e, $vars)
};

declare function shacl-apply:resolveFunctions($sp) {
  let $funcPrefixes := "(" || fn:string-join(map:keys($shacl-services:pxMap) ! (. || ":"), "|") || ")"
  let $func := $funcPrefixes || "([a-zA-Z0-9_]*)([\s]*)"
  let $funcWithoutArg := ($func || "\([\s]*\)")
  let $funcWithArg := ($func || "\(")
  let $sp := fn:replace($sp, $funcWithoutArg, "xdmp:apply(\$shapply, '$1$2')")
  let $sp := fn:replace($sp, $funcWithArg, "xdmp:apply(\$shapply, '$1$2', ")
  return $sp
};
