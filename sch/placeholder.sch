<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="http://www.w3.org/2001/XInclude" prefix="xi"/>
    
    
    
    <!-- Check @status -->
    <!-- ============= -->
    
    <sch:pattern id="id-empty-status">
        <sch:title>Empty @id</sch:title>
        <sch:rule context="*[@id]">
            <sch:assert test="@id !=''">@id should never be empty</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
</sch:schema>