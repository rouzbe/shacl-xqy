# shacl-xqy
In-memory retrieval and execution of SHACL functions (SPARQL, JS/SJS and XQuery) in MarkLogic XQuery.

## Summary
It allows executing SPARQL, XQuery and JavaScript functions within SPARQL queries according to SHACL specifications. For example, you can do something like this:

```
SELECT (ex:JSMultiply(ex:SPARQLMultiply(3, 5), ex:XQueryMultiply(7, 11)) AS ?result) WHERE { }
```

where `ex:SPARQLMultiply`, `ex:XQueryMultiply` and `ex:JSMultiply` are reusable functions defined in SPARQL, XQuery and JavaScript, respectively.

## Examples

After setting up the database and application server, you should be able to navigate to [http://localhost:8016](http://localhost:8016) to see the examples.

### Create and Setup the Database and App Server
Run the following codes in MarkLogic Query Console. Make sure you replace `~PATH~` with the right path to the `shacl-xqy` folder:

```
import module namespace admin = "http://marklogic.com/xdmp/admin"
         at "/MarkLogic/admin.xqy";

(: Get the configuration :)
let $config := admin:get-configuration()

(: Add new database to the configuration :)
let $config := admin:database-create(
    $config,
    "SHACL-XQuery-Test-DB",
    xdmp:database("Security"),
    xdmp:database("Schemas"))

(: Obtain the database ID of 'SHACL-XQuery-Test-DB' :)
let $SHACL-XQuery-Test-DB := admin:database-get-id(
    $config,
    "SHACL-XQuery-Test-DB")

(: Add a new forest :)
let $config := admin:forest-create(
    $config,
    "SHACL-XQuery-Test-DB-Forest",
    xdmp:host(), ())

let $save := admin:save-configuration($config)

(: Attach the "SHACL-XQuery-Test-DB-Forest" forest to 'SHACL-XQuery-Test-DB' :)
let $config := admin:database-attach-forest(
    $config,
    $SHACL-XQuery-Test-DB,
    xdmp:forest("SHACL-XQuery-Test-DB-Forest"))

(: Add a triple index to 'SHACL-XQuery-Test-DB' :)
let $config := admin:database-set-triple-index(
    $config,
    $SHACL-XQuery-Test-DB,
    fn:true())

(: Create an App Server :)
let $config := admin:http-server-create(
    $config,
    admin:group-get-id($config, "Default"),
    "SHACL-XQuery-Test-Server",
    "~PATH~/shacl-xqy/",
    8016,
    "file-system",
    $SHACL-XQuery-Test-DB)

return
    admin:save-configuration($config)
```

### Load SHACL Resources and Example Data
Download [MLCP](https://docs.marklogic.com/guide/mlcp/install) and run the following commands. Make sure you replace `~PATH~` with the right path to the `shacl-xqy` folder and `~USER~` and `~PASS~` with your MarkLogic admin credentials:

```
sh mlcp.sh import \
  -host localhost -port 8000 \
  -username ~USER~ -password ~PASS~ \
  -database shacl-xqy-test-db \
  -input_file_path "~PATH~/resources/*.ttl","~PATH~/examples/examples.ttl" -input_file_type RDF \
  -mode local
```

### Cleanup the Database
In case you want to modify and reload the data, you first need to delete the existing triples. Run this in Query Console in the SPARQL Update mode:
```
CLEAR GRAPH <http://marklogic.com/semantics#default-graph>
```
### Delete the Database, Forest and App Server
```
import module namespace admin = "http://marklogic.com/xdmp/admin"
		  at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()

let $config := admin:appserver-delete(
    $config,
    admin:appserver-get-id(
      $config,
      admin:group-get-id($config, "Default"),
      "SHACL-XQuery-Test-Server"))

let $save := admin:save-configuration($config)

let $config := admin:database-delete(
    $config,
    admin:database-get-id(
      $config,
      "SHACL-XQuery-Test-DB"))

let $save := admin:save-configuration($config)

let $config := admin:forest-delete(
    $config,
    admin:forest-get-id(
      $config,
      "SHACL-XQuery-Test-DB-Forest"),
    true())

return
    admin:save-configuration($config);
```
