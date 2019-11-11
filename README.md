# Blazegraph Data Load Scripts and Commands


**Blazegraph Local Bulk Load Script - BGLocalBulkLoad.sh**

The script BGLocalBulkLoad.sh may be used to create and/or load RDF data into a local Blazegraph database instance.
The data files may be compressed using zip or gzip, but the script does not support multiple data files within a single archive.
This script should be used only for the very big dumps!

**Requirements**

* Linux OS
* Git
* Gitlab account and membership in the ACDH-OEAW group
* Enough space on disks on varuna and local server where the script will be executed
* Enough RAM
* Valid RDF dump
* ACDH users should know their the database name if it is deployed on varuna.arz.oeaw.ac.at

**How to use script BGLocalBulkLoad.sh**

Login to your project (linux account) over ssh: ssh projectname@servername.arz.oeaw.ac.at 
1. Clone the bgload project by: git clone https://gitlab.com/acdh-oeaw/bgload.git
2. Change to the bgload dir: cd bgload
3. Make a directory for the rdf files or the dump: mkdir dump
4. Put your rdf files or dumps in the dump dir
5. Get the fresh clone of your database from varuna. The database name ends with .jnl and can be provided by ACDH sysadmins. The database should be copied to the bgload dir.

**Instructions for ACDH sysadmins**

To clone the database from varuna to some project
* login to varuna over ssh ssh useername@varuna.arz.oeaw.ac.at
* switch to the jetty user: sudo bash & su jetty
* add following public ssh key to the project in which you want to copy the database 

`ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUec2dufEVYHQjg3jmm+DVTWxdZ/+jeLn69EcQ90L8DBi+uiyapieec4n5OSc2CFj8CZgNQrBkTCP01g1uNkbqkmQMzMJPtzgg1PHg0xizmbybDaKEV7ewIDvk7jJeXob+Fq1ZwIc8QEJs0i4l8BFeQN6HwWdtbyA3V+/N7OYsBJNdJCQRJJvJrio+g/eA4wYal6Q2InaEauQWQyho5UWIKRJZ20oCR8PFaHG5+HHBj6tNcYK3C68bTHrrwz2d6AVBbkCTgeWjUkSaQ/2iA9w4jqJTJ9LE97ryxHX4MNKONu9AkndkZp+F9DCQTV3nz6eTJPdB5c2qQMy6Ys+Eu63rLCxLWAWjCgW9Z3f72kSrcEa8Iulc/vKuNuxjFXDEOFcZXgddKX5cMOdtpaxZfrKWeRhryTAIrNaIuYaLZX8bquXUL1UgBSdnufcEy/24Uehaz5G+HyJKNgd/XYVwADkC7aI2KtRuflC9SJGRf4TzIQQ4tMtEuwpjQn0v9nwr73/Lfw7QANdvy0vVtt1Mxw02wy/Zh4p8bpX4QuCWEg4Vi2HCGqvVQcR1zjegug0tnFRM+8+pimT+5nt/rvg5ueGnxuOtut9XK89mQU3fPCmnAxkyIYM76vqP91F0o+YalO1eGHppY7ClW9vW7O0GQB6ODFg8NnE21Mx986OkseA0VQ== blazegraph.varuna@oeaw.ac.at`

* Execute: scp /opt/jetty/acdh_base/blazegraph/dbname.jnl projectname@servername.arz.oeaw.ac.at:/home/projectname/path-to-the-bgload-dir/;

6. Make sure that script has rights to execute: chmod +x BGLocalBulkLoad.sh
7. Start new screen session by typing screen and execute the BGLocalBulkLoad.sh script: ./BGLocalBulkLoad.sh 

* After executing, script will ask you for some input parameters:
* Please enter amount of RAM that will be used for processing (Example:8g) - Make sure that server has enough RAM but specifying 8g should be available on all ACDH servers.
* Please enter db name (Example: go-db): - If the database is deployed on varuna specify that name and if not you can choose the name for the database.
* Please enter namespace in wich data will be stored (Default is: kb): - The default namespace is kb.
* Please enter path to the directory that is containing data that should be imported: - Here should be the name of the dir that will contain rdf files. If you followed instructions from above the name should be the dump. 
* Please specify the default graph. This is required for quads mode (Example: http://example.org): - Add the graph name under which your dump will be imported.


8. Leave the screen session by executing: ctrl + a + d 
9. Check log file in the dir named logs that is automatically created by the script.
10. After some time to return back to the screen session type: screen -r. The importing time depends on the dump size and available resources on the server. 
11. When you finished with importing ask ACDH sysadmin to replace your database on varuna by the new database.

**Instructions for ACDH sysadmins**

To copy and deploy new databasae to varuna make sure that there is enough free space on the disk on varuna. It is NAS partition that is mounted in /opt/jetty/acdh_base
* Login to varuna over ssh: ssh user@varuna.arz.oeaw.ac.at 
* Switch to the jetty user: sudo bash & su jetty
* Make backup of old database by executing: cp /opt/jetty/acdh_base/blazegraph/dbname.jnl /opt/jetty/acdh_base/blazegraph/back_date_dbname.jnl
* Copy new database: scp projectname@servername.arz.oeaw.ac.at:/home/projectname/path-to-the-bgload-dir/dbname.jnl /opt/jetty/acdh_base/blazegraph/dbname.jnl
* Restart jetty on varuna: service jetty restart.
* Inform user that the database is deployed. 
* If everything is okay, remove backup file: rm -f /opt/jetty/acdh_base/blazegraph/back_date_dbname.jnl


**Blazegraph Rest API Script - BGloadRestAPI.sh**

The script BGloadRestAPI.sh may be used to **load multiple RDF files** into a remote Blazegraph database instance.
This script should be used only for smaller dumps!

**Requirements**

* Linux OS
* Git
* Gitlab account and membership in the ACDH-OEAW group
* Enough space on disks on local server where the script will be executed
* Valid RDF dump
* curl
* The database name credentials if the database is deployed on varuna


**How to use script BGloadRestAPI.sh**

1. Login to your project (linux account) over ssh: ssh projectname@servername.arz.oeaw.ac.at 
2. Clone the bgload project by: git clone https://gitlab.com/acdh-oeaw/bgload.git
3. Change to the bgload dir: cd bgload
4. Make a directory for the rdf files or the dump: mkdir dump
5. Put your rdf files or dumps in the dump dir
6. Make sure that script has rights to execute: chmod +x BGloadRestAPI.sh
7. Start new screen session by typing screen and execute the BGloadRestAPI.sh script by typing: ./BGloadRestAPI.sh 
8. Leave the screen session by executing: ctrl + a + d 
9. After some time to return back to the screen session type: screen -r
10. At the end when you finish with importing type exit to remove the screen session.

After executing script will ask you for some input parameters:

* Please enter database name: - Specify the database name
* Please enter database user: - Specify the database user (on varuna it is usualy the same as the database name)
* Please enter database password: - Enter the db password
* Please enter path to the directory with the rdf files (Example:dump): - Enter the name of the directory you created in step 4. (If you followed instructions the name is the dump)
* Please specify the default graph. This is required for quads mode. (Example: http://example.org): - Add the graph name under which your dump will be imported.
* Please specify the MIME Type (Example: application/rdf+xml): - Specify the MIME type of files you want to import. Following mimetypes can be used:

| MIME Type                                         | File extension          | Charset  | Name                                  | URL                                                      | RDR? | Comments                                                                    |
|---------------------------------------------------|-------------------------|----------|---------------------------------------|----------------------------------------------------------|------|-----------------------------------------------------------------------------|
| application/rdf+xml                               | .rdf, .rdfs, .owl, .xml | UTF-8    | RDF/XML                               | http://www.w3.org/TR/REC-rdf-syntax/                     |      |                                                                             |
| application/ld+json                               | .jsonld                 | UTF-8    | JSON-LD                               | https://www.w3.org/TR/json-ld/                           | No.  | Supported since 2.0.2: BLZG-1017                                            |
| text/plain                                        | .nt                     | US-ASCII | N-Triples                             | http://www.w3.org/TR/rdf-testcases/#ntriples             |      | N-Triples defines an escape encoding for non-ASCII characters.              |
| application/x-n-triples-RDR                       | .ntx                    | US-ASCII | N-Triples-RDR                         | http://www.w3.org/TR/rdf-testcases/#ntriples             | Yes  | This is a bigdata specific extension of N-TRIPLES that supports RDR.        |
| application/x-turtle                              | .ttl                    | UTF-8    | Turtle                                | http://www.w3.org/TeamSubmission/turtle/                 |      |                                                                             |
| application/x-turtle-RDR                          | .ttlx                   | UTF-8    | Turtle-RDR                            | http://www.bigdata.com/whitepapers/reifSPARQL.pdf        | Yes  | This is a bigdata specific extension that supports RDR.                     |
| text/rdf+n3                                       | .n3                     | UTF-8    | N3                                    | http://www.w3.org/TeamSubmission/n3/                     |      |                                                                             |
| application/trix                                  | .trix                   | UTF-8    | TriX                                  | http://www.hpl.hp.com/techreports/2003/HPL-2003-268.html |      |                                                                             |
| application/x-trig                                | .trig                   | UTF-8    | TRIG                                  | http://www.wiwiss.fu-berlin.de/suhl/bizer/TriG/Spec      |      |                                                                             |
| text/x-nquads                                     | .nq                     | US-ASCII | NQUADS                                | http://sw.deri.org/2008/07/n-quads/                      |      | Parser only before bigdata 1.4.0.                                           |
| application/sparql-results+json, application/json | .srj, .json             | UTF-8    | Bigdata JSON interchange for RDF/RDF* | N/A                                                      | Yes  | bigdata json interchange supports RDF RDR data and also SPARQL result sets. |

**Other useful Blazegraph's Rest API commands:**

How to **make a dump** over Blazegraph's Rest API

`curl -X POST http://dbuser:dbpassword@varuna.arz.oeaw.ac.at:8080/dbname/sparql --data-urlencode 'query=CONSTRUCT WHERE {?s ?p ?o }' -H 'Accept:application/rdf+xml'  > db_dump.rdf`

How to **upload a single file** over Blazegraph's Rest API

`curl -X POST -H 'Content-Type:application/rdf+xml' --data-binary '@yourdump.rdf' http://dbuser:dbpassword@varuna.arz.oeaw.ac.at:8080/dbname/sparql?context-uri=http://example.org` 

How to **update** database over Blazegraph's Rest API 

`curl  https://dbuser:dbpassword@varuna.arz.oeaw.ac.at:8080/dbname/sparql -H 'Content-Type: application/sparql-update; charset=UTF-8' -H 'Accept: text/boolean' -d@your-sparql.file`
