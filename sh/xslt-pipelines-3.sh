#!/bin/sh

#! /bin/sh -
PROGNAME=$0

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-r <root>] [-i <input>] [-t <output>]

-r <root>: repository root
-i <input>: input path
-t <output>: output path
EOF
  exit 1
}

root=default_root input=default_in output=default_out
while getopts r:i:t: o; do
  case $o in
    (r) root=$OPTARG;;
    (i) input=$OPTARG;;
    (t) output=$OPTARG;;
    (*) usage
  esac
done
shift "$((OPTIND - 1))"

echo Remaining arguments: "$@"

echo "Running" $PROGNAME
echo "Input path" $input
echo "Output base path" $output

#PROJECT=`cd $1; pwd`
# XSLT_MANIFEST=$1 # Path to XSLT manifest XML
#SCH=$2 # Schematron for output
#$SOURCES=$3 # Path to sources
#TMP=$2 # Output base
#$PUBLIC_ID=$5
#$SYSTEM_ID=$6
#$XSPEC_MANIFEST=$7 # XSpec manifest file
#VERBOSE=$8 # Verbose output? true/false
#DEBUG=$9 # Output debug? true/false
#DTD_VALIDATE_INPUT=$10 # Validate input
#DTD_VALIDATE_OUTPUT=$11 # Validate output
#SCH_VALIDATE_OUTPUT=$12 # Validate output with Schematron
#RUN_XSPECS=$13 # Run XSpecs - leave to false now!

#ROOT=`cd $(dirname $(realpath -s $0))/..; pwd`

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
$root/../xproc-batch/xproc/validate-convert.xpl \
-catalogs=$root/../xproc-batch/catalogs/catalog.xml \
-input:manifest=/home/ari/Documents/repos/xslt-pipelines/pipelines/test-manifest.xml \
-input:sch=$root/sch/placeholder.sch \
-option:input-base-uri=$input \
-option:output-base-uri=$output/out \
-option:reports-dir=$output/reports \
-option:tmp-dir=$output \
#-option:doctype-public=$PUBLIC_ID \
#-option:doctype-system=$SYSTEM_ID \
#-option:xspec-manifest-uri=$XSPEC_MANIFEST \
#-option:verbose=true \
#-option:debug=true \
#-option:dtd-validate-input=$DTD_VALIDATE_INPUT \
#-option:dtd-validate-output=$DTD_VALIDATE_OUTPUT \
#-option:sch-validate-output=$SCH_VALIDATE_OUTPUT \
#-option:run-xspecs=$RUN_XSPECS
