module namespace shacl-queries = "shacl-queries";

declare variable $px := "
  PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
  PREFIX sh:    <http://www.w3.org/ns/shacl#>
  PREFIX owl:   <http://www.w3.org/2002/07/owl#>
";

declare variable $getFunctionType := "
  SELECT ?type
  WHERE {
    ?this a ?type .
    ?type rdfs:subClassOf+ sh:Function .
  }
";

declare variable $getSPARQLFunctionSelectQuery := "
  SELECT ?select
  WHERE {
    ?this a sh:SPARQLFunction ;
      sh:select ?select .
  }
";

declare variable $getFunctionParameters := "
  SELECT ?parameter ?path ?datatype ?hasClass
  WHERE {
    ?this a sh:SPARQLFunction ;
      sh:parameter ?parameter .
    ?parameter sh:path ?path .
    OPTIONAL {
      ?parameter sh:order ?o .
    }
    OPTIONAL {
      ?parameter sh:datatype ?datatype .
    }
    BIND(
      EXISTS {
        ?parameter sh:class ?class .
      } AS ?hasClass
    )
    BIND(COALESCE(?o, 0) AS ?order)
  }
  ORDER BY ?order
";

declare variable $getJSFunction := "
  SELECT DISTINCT ?jsFunctionName ?jsLibraryURL
  WHERE {
    ?this a/rdfs:subClassOf* sh:JSFunction ;
      sh:jsFunctionName ?jsFunctionName ;
      sh:jsLibrary [
        a sh:JSLibrary ;
        sh:jsLibraryURL ?jsLibraryURL ;
      ]
  }
";

declare variable $getPrefixDeclarations := "
  SELECT DISTINCT ?prefix ?namespace
  WHERE {
    []
      a owl:Ontology ;
        sh:declare [
          sh:prefix ?prefix ;
          sh:namespace ?namespace ;
        ] .
  }
";
