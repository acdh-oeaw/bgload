#!/bin/sh

# Take user input needed for the Blazegraph configuration
read -p 'Please enter amount of RAM that will be used for processing (Example:8g): ' RAM
read -p 'Please enter db name (Example: go-db): ' DB_NAME
read -p 'Please enter namespace in wich data will be stored (Default is: kb): ' NAMESPACE
read -p 'Please enter path to the directory that is containing data that should be imported: ' IMPORTDIR
read -p 'Please specify the default graph. This is required for quads mode (Example: http://example.org): ' DEFAULGRAPH

# Blazegraph download URL
BLAZEGRAPH=https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_RELEASE_CANDIDATE_2_1_5/blazegraph.jar

# Check if Blazegraph is already downloaded
if [ -f "blazegraph.jar" ];
then
  echo "Blazegraph is already downloaded";
else
  echo "Download Blazegraph"
wget $BLAZEGRAPH
chmod +x blazegraph.jar
fi

# Check if log dir exist
if [ -d "logs" ];
then
  echo "Log dir already exist";
else
  echo "Creating log directory"
mkdir logs
fi

echo "Cleaning old stuff"

# Remove old property file
rm -f propertyFile

# Remove old logs
rm -f rules.log

# Remove old database
read -p "Remove old $DB_NAME.jnl? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm -f $DB_NAME.jnl
    echo "The $DB_NAME.jnl removed"
fi

echo "The $DB_NAME.jnl is not removed and new data will be added to it"
# Make config file:
echo "Creating new config file"
touch propertyFile

#Enter configuration

echo "Entering BG configuration"

cat > propertyFile <<- EOM
com.bigdata.journal.AbstractJournal.file=$DB_NAME.jnl
com.bigdata.journal.AbstractJournal.bufferMode=DiskRW
com.bigdata.service.AbstractTransactionService.minReleaseAge=1
com.bigdata.btree.writeRetentionQueue.capacity=4000
com.bigdata.btree.BTree.branchingFactor=128
com.bigdata.journal.AbstractJournal.initialExtent=209715200
com.bigdata.journal.AbstractJournal.maximumExtent=209715200
com.bigdata.namespace.kb.lex.com.bigdata.btree.BTree.branchingFactor=400
com.bigdata.namespace.kb.lex.ID2TERM.com.bigdata.btree.BTree.branchingFactor=600
com.bigdata.namespace.kb.lex.TERM2ID.com.bigdata.btree.BTree.branchingFactor=330
com.bigdata.namespace.kb.spo.com.bigdata.btree.BTree.branchingFactor=1024
com.bigdata.namespace.kb.spo.OSP.com.bigdata.btree.BTree.branchingFactor=900
com.bigdata.namespace.kb.spo.SPO.com.bigdata.btree.BTree.branchingFactor=900
com.bigdata.rdf.sail.bufferCapacity=100000
com.bigdata.journal.AbstractJournal.writeCacheBufferCount=1000
com.bigdata.rwstore.RWStore.smallSlotType=1024
com.bigdata.journal.AbstractJournal.historicalIndexCacheCapacity=20
com.bigdata.journal.AbstractJournal.historicalIndexCacheTimeout=5
com.bigdata.rdf.sail.truthMaintenance=false
com.bigdata.rdf.store.AbstractTripleStore.quads=true
com.bigdata.rdf.store.AbstractTripleStore.statementIdentifiers=false
com.bigdata.rdf.store.AbstractTripleStore.textIndex=true
com.bigdata.rdf.store.AbstractTripleStore.axiomsClass=com.bigdata.rdf.axioms.NoAxioms
com.bigdata.rdf.store.DataLoader.closure=None
com.bigdata.rdf.store.DataLoader.ignoreInvalidFiles=true
EOM

echo "Configuration file created"

# Import data

echo "Importing data in $DB_NAME.jnl"

java  -Xmx${RAM} -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 \
      -XX:MaxHeapFreeRatio=20 -XX:MinHeapFreeRatio=10 -XX:GCTimeRatio=20 \
      -cp blazegraph.jar \
      com.bigdata.rdf.store.DataLoader \
      -defaultGraph ${DEFAULGRAPH} \
      -namespace ${NAMESPACE} \
      -verbose  \
      propertyFile ${IMPORTDIR}/*  >> logs/log-import-made-at-`date +\%Y-\%m-\%d_\%H:\%M:\%S`-by-imporscript.log 2>&1

echo "Done. Please check log file log-import-made-at....in logs directory"