# README

This repository contains a test pipeline for XSLT steps, meaning individual XSLT stylesheets (steps) and a manifest file that describes the order in which the steps run. It is intended only to test the [XProc batch, branch xproc3](https://github.com/sgmlguru/xproc-batch/tree/xproc3) tools that in turn rely on [my fork](https://github.com/sgmlguru/xproc-tools/tree/xproc3) of Nic Gibson's [XProc Tools](https://github.com/Corbas/xproc-tools).

You can also run the manifest in eXist-DB, without Nic's XProc Tools. See the XProc Batch repository's XQuery scripts.


## Contents

* `sources/input.xml` is a single input test XML file
* `xslt/` contains four XSLT steps
* `pipelines/` contains a single XML manifest file that defines the test pipeline
* `xspec/` contains an XSpec unit test
* `tests/` contains an XSpec manifest file
* `sh/` contains a shell script to run the test pipeline


## Setup

1. Download and install [MorganaXProc-III](https://www.xml-project.com/morganaxproc-iii/).
2. Clone [XProc Batch](https://github.com/sgmlguru/xproc-batch/tree/xproc3), branch xproc3.
3. Clone this repository as a sibling folder to XProc Batch.
4. Edit `sh/xslt-pipelines-3.sh` and the `MORGANA_HOME` variable to match your MorganaXProc-III location.



## Running

To run the test pipeline, open a command line and follow these steps:

1. Enter `cd $ROOT` where `$ROOT` is the path to this repository on your system. Hit RETURN.
2. Enter `sh sh/xslt-pipelines-3.sh -i $PROJECT -t $TMP` where `$PROJECT` points to the folder where your input XML files live and `$TMP` points at the target location for the results. For example: `sh sh/xslt-pipelines-3.sh -i file:/home/ari/Documents/repos/xslt-pipelines/sources/ -t file:/home/ari/Documents/repos/xslt-pipelines/tmp/`. Hit RETURN.

NOTE: The paths need to be absolute file URLs on Linux systems at the moment. Not sure why.

The pipeline creates a `tmp` folder, inside which it saves the converted file, plus debug information. For details, see the XProc Batch `README.md`.


## Test Input File

The test input file `input.xml` is this rather unimaginative file:

```
<doc>
    <section>
        <title>My title</title>
        <p>My paragraph</p>
    </section>
</doc>
```


## Output

The output after four XSLT steps should look like this:

```
<four three="value3A-value3B" one="value1">
    <four three="value3A-value3B" one="value1">
        <four three="value3A-value3B" one="value1">My title</four>
        <four three="value3A-value3B" one="value1">My paragraph</four>
    </four>
</four>
```


## Pipeline Manifest

The pipeline manifest in `pipelines/` looks like this:

```
<manifest xmlns="http://www.corbas.co.uk/ns/transforms/data" xml:base=".">
    
    <group description="..." xml:base="../xslt/">
        <item href="step1.xsl" description="To element one">
            <meta name="param1" value="value1"/>
        </item>
        <item href="step2.xsl" description="To element two"/>
        <item href="step3.xsl" description="To element three">
            <meta name="param3A" value="value3A"/>
            <meta name="param3B" value="value3B"/>
        </item>
        <item href="step4.xsl" description="To element four"/>
    </group>
    
</manifest>
```

The manifest validates against Nic's manifest Relax NG schema, found in his XProc Tools repository.

You'll notice that two of the steps include `meta` elements. These describe input parameters to the respective XSLT steps.


## XSLT Steps

The four XSLT step stylesheets in `xslt/` are basically the same. Here's the first one:

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="param1"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="STEP-1"/>
    </xsl:template>
    
    
    <xsl:template match="*" mode="STEP-1" priority="1">
        <one one="{$param1}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="STEP-1"/>
        </one>
    </xsl:template>
    
    
    <xsl:template match="node()" mode="STEP-1">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="STEP-1"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
```

The following three are mostly the same. Steps #1 and #3 have input parameters, #2 and #4 do not.


## Pipeline-based XSLT Development

The whole idea behind pipeline-based XSLT development is to *isolate concerns*, bringing down the size of any individual XSLT stylesheet and thus making the transform easier to understand and therefore easier to debug. If you transform only semantically similar things in a step (say, lists) and copy anything that isn't a list to the output, verbatim, chances are that your step will make more sense to someone new to your code because everything in your step will be about lists.

Also, when dividing your development into shorter and more focussed steps, you can save the output from each step and use those to debug your XSLTs. The trick will then become to spot where the transform went wrong, in what step, and then look through (and debug) the steps you think might be the culprits in your favourite XSLT editor.

And, of course, if (when, actually) you realise that your step's grown to be too big and you need to refactor it into multiple steps *and* add more functionality, that too becomes much easier because you can simply write your new XSLTs and stick them in between two existing ones in the manifest.

This approach to development is extremely useful and will almost certainly transform (pun intended) your XSLT development. Also, you're likely to be able to do things that were not easily accessible to a more monolithic approach. What if you need to transform your entire document to a temporary structure before you can move on to transforming that format to your end format? It's certainly possible to do in a monolithic XSLT but will most likely require in-styleet variables, all of which will consume space but be nearly impossible to debug.

(It's possible, of course; mostly anything is, but if you're running things in batch with multiple input documents and you know you'll want to debug, well, good luck with that.)


