#!/bin/bash

# Take user input needed for the Blazegraph configuration

read -p 'Please enter database name: ' DB_NAME
read -p 'Please enter database user: ' DB_USER
read -p 'Please enter database password: ' DB_PASS
DB_SERVER=varuna.arz.oeaw.ac.at:8080
read -p 'Please enter path to the directory with the rdf files (Example:dump): ' DUMP
read -p 'Please specify the default graph. This is required for quads mode. (Example: http://example.org): ' DEFAULT_GRAPH
read -p 'Please specify the MIME Type (Example: application/rdf+xml): ' MIME_TYPE

# Upload dump files to the Blazegraph by curl

for file in $DUMP/*

do
    echo "importing: $file to the db on $DB_SERVER"
    curl -X POST -H 'Content-Type:'$MIME_TYPE --data-binary @$file http://$DB_USER:$DB_PASS@$DB_SERVER/$DB_NAME/sparql?context-uri=$DEFAULT_GRAPH
    echo "$file is imported to the db on $DB_SERVER"

echo "done."
done; 