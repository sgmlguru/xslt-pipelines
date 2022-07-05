#!/bin/sh

MORGANA_HOME=/home/ari/MorganaXProc-IIIse-0.9.16-beta
MORGANA_LIB=$MORGANA_HOME/MorganaXProc-IIIse_lib/*

#Settings for JAVA_AGENT: Only for Java 8 we have to use -javaagent.
JAVA_AGENT=""

JAVA_VER=$(java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*".*/\1\2/p;')

if [ $JAVA_VER = "18" ]
then
	JAVA_AGENT=-javaagent:$MORGANA_HOME/MorganaXProc-IIIse_lib/quasar-core-0.7.9.jar
fi

# All related jars are expected to be in $MORGANA_LIB. For externals jars: Add them to $CLASSPATH
CLASSPATH=$MORGANA_LIB:$MORGANA_HOME/MorganaXProc-IIIse.jar

java \
$JAVA_AGENT \
-cp $CLASSPATH com.xml_project.morganaxproc3.XProcEngine \
-config=$MORGANA_HOME/config.xml \
../xproc-batch/xproc/validate-convert.xpl \
-catalogs=../xproc-batch/catalogs/catalog.xml \
-input:manifest=./pipelines/test-manifest.xml \
-input:sch=/home/ari/Documents/repos/xslt-pipelines/sch/placeholder.sch \
-option:input-base-uri='/home/ari/Documents/repos/xslt-pipelines/sources' \
-option:output-base-uri='/home/ari/Documents/repos/xslt-pipelines/tmp/out' \
-option:reports-dir=/home/ari/Documents/repos/xslt-pipelines/tmp/reports \
-option:tmp-dir=/home/ari/Documents/repos/xslt-pipelines/tmp \
#-option:doctype-public=$PUBLIC_ID \
#-option:doctype-system=$SYSTEM_ID \
#-option:xspec-manifest-uri=$XSPEC_MANIFEST \
#-option:verbose=true \
#-option:debug=true \
#-option:dtd-validate-input=$DTD_VALIDATE_INPUT \
#-option:dtd-validate-output=$DTD_VALIDATE_OUTPUT \
#-option:sch-validate-output=$SCH_VALIDATE_OUTPUT \
#-option:run-xspecs=$RUN_XSPECS
