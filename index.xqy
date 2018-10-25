import module namespace shacl-xqy = "shacl-xqy"
  at "src/shacl.xqy";
(
xdmp:set-response-content-type("text/html;charset=UTF-8"),
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title>SHACL-XQuery Examples</title>
</head>

<body>
  <h1>SHACL-XQuery Examples</h1>
  <h2>SPARQL Functions</h2>
  <p>
    <h3>Query</h3>
    <pre>
      SELECT (ex:SPARQLMultiply(3, 5) AS ?result) WHERE &#123; &#125;
    </pre>
  </p>
  <p>
    <h3>Results</h3>
    <pre>
      {shacl-xqy:sparql("SELECT (ex:SPARQLMultiply(3, 5) AS ?result) WHERE {}")}
    </pre>
  </p>
  <p>
    <h3>Query</h3>
    <pre>
      SELECT (ex:SPARQLGetLabel(ex:SPARQLGetLabel) AS ?result) WHERE &#123; &#125;
    </pre>
  </p>
  <p>
    <h3>Results</h3>
    <pre>
      {shacl-xqy:sparql("SELECT (ex:SPARQLGetLabel(ex:SPARQLGetLabel) AS ?result) WHERE {}")}
    </pre>
  </p>
  <h2>XQuery Functions</h2>
  <p>
    <h3>Query</h3>
    <pre>
      SELECT (ex:XQueryMultiply(7, 11) AS ?result) WHERE &#123; &#125;
    </pre>
  </p>
  <p>
    <h3>Results</h3>
    <pre>
      {shacl-xqy:sparql("SELECT (ex:XQueryMultiply(7, 11) AS ?result) WHERE {}")}
    </pre>
  </p>
  <h2>JS Functions</h2>
  <p>
    <h3>Query</h3>
    <pre>
        SELECT (ex:JSMultiply(ex:SPARQLMultiply(3, 5), ex:XQueryMultiply(7, 11)) AS ?result) WHERE &#123; &#125;
    </pre>
  </p>
  <p>
    <h3>Results</h3>
    <pre>
        {shacl-xqy:sparql("SELECT (ex:JSMultiply(ex:SPARQLMultiply(3, 5), ex:XQueryMultiply(7, 11)) AS ?result) WHERE {}")}
    </pre>
  </p>
  <br />
  <p>
    <h3>Query</h3>
    <pre>
      SELECT (ex:JSGetRandom() AS ?result) WHERE &#123; &#125;
    </pre>
  </p>
  <p>
    <h3>Results</h3>
    <pre>
      {shacl-xqy:sparql("SELECT (ex:JSGetRandom() AS ?result) WHERE {}")}
    </pre>
  </p>
</body>

</html>
)
