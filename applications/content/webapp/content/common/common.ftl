<#-- SCIPIO: Common content macros and definitions -->

<#-- Special localized text field macros
    Intended for ProductContent/ProductCategoryContent fields with ALTERNATE_LOCALE support,
    but this should support anything fitting that entity pattern. -->

<#-- Parses simple text content localized field initial value params for paramNamePrefix. -->
<#function parseStcLocFieldParams params paramNamePrefix="" allowPreparsed=false>
  <#return toSimpleMap(Static["org.ofbiz.product.category.CategoryWorker"].parseLocalizedSimpleTextContentFieldParams(params, paramNamePrefix, allowPreparsed)!{})>
</#function>

<#-- Retrieves the incoming initial values for localized field from params[parsedParamName], 
    or if not set, parses them from params for paramNamePrefix.
    This way, supports both pre-parse from groovy and standalone operation. -->
<#function getStcLocFieldParsedParams params parsedParamName="" paramNamePrefix="" allowPreparsed=false>
  <#if parsedParamName?has_content && params[parsedParamName]?? && params[parsedParamName]?is_hash>
      <#return toSimpleMap(params.simpleTextViewsByType)>
  <#elseif paramNamePrefix?has_content>
    <#return parseStcLocFieldParams(params, paramNamePrefix, allowPreparsed)>
  </#if>
</#function>

<#function makeStcLocFieldNamePrefix paramNamePrefix typeName entityFieldName index>
    <#return rawString(Static["org.ofbiz.product.category.CategoryWorker"].makeLocalizedSimpleTextContentFieldStringParamPrefix(paramNamePrefix, typeName, index))>
</#function>

<#-- Outer container markup for @stcLocField
    Includes a hidden entry markup template for javascript (there is some redundancy, but having it
    here simplifies code and is REQUIRED due to styling problems with @row/@cell when the template
    is stored elsewhere). -->
<#macro stcLocFieldContainer containerClass="" onAddClick="" wrapperArgs={} entryTmpl=false extraTmpl="" entryArgs={} extraArgs...>
    <#local containerClass = addClassArg(containerClass, "+stc-locfield")>
    <@field type="general" containerClass=containerClass args=wrapperArgs><#t/>
      <div class="stc-locfield-entries"><#nested></div><#t/>
      <div class="stc-locfield-add-cnt"><a href="javascript:void(0);" class="stc-locfield-add"<#t/>
        <#if onAddClick?has_content> onClick="${onAddClick}"</#if>>[+]</a></div><#t/>
      <#if !entryTmpl?is_boolean>
        <div style="display:none;"><#t/>
          <div class="stc-markup-locFieldEntry"><#if entryTmpl?is_directive><@entryTmpl args=entryArgs/><#else>${entryTmpl}</#if></div><#t/>
        </div><#t/>
      </#if>
      <#if extraTmpl?is_directive><@extraTmpl/><#else>${extraTmpl}</#if>
    </@field><#t/>
</#macro>

<#-- Entry markup template for @stcLocField 
    This must support a no-argument invocation for the JS template. -->
<#macro stcLocFieldEntry args={} extraArgs...>
  <#local entryData = args.entryData!{}>
  <@row class="+stc-locfield-entry"><#t/>
    <@cell small=2><#t/>
      <@field type="select" name=(args.localeFieldName!"") class="+stc-locfield-locale"><#t/>
        <#local localeOpts = args.localeOpts!{}>
        <@listLocaleMacros.availableLocalesOptions expandCountries=(localeOpts.expandCountries!true) 
            allowExtra=(localeOpts.allowExtra!true) allowEmpty=(localeOpts.allowEmpty!true)
            currentLocale=(entryData.localeString!)/><#t/>
      </@field><#t/>
    </@cell><#t/>
    <@cell small=10><#t/>
      <@field type=(args.inputType!"input") args=(args.inputArgs!{}) name=(args.textFieldName!"") class="+stc-locfield-text" value=(entryData.textData!)/><#t/>
    </@cell><#t/>
  </@row><#t/>
</#macro>

<#-- Simple text content localized field, a simple text input with separate entries for each locale.

    REQUIRES:
    * /content/images/ScpContentCommon.js (StcLocFieldHandler)
    
    Creates the initial localized fields for ProductContent/ProductCategoryContent ALTERNATE_LOCALE fields
    at initial load (event error), but also supports other types of localized fields.
    
    values can be a hash of typeNames to entryDataLists, or a single entryDataLists,
    or if not specified, it will be looked up in params using getStcLocFieldParsedParams.
    
    The markup and especially name-building function can be overridden in the parameters 
    to suit the service/event.
    
    entityFieldName is auto-determined from typeName if not passed.
    
    Example:
        <@stcLocField typeName="PRODUCT_NAME"
            paramNamePrefix="contentField_" params=parameters label=uiLabelMap.ProductProductName
            inputType="textarea"/>
    -->
<#macro stcLocField typeName paramNamePrefix entityFieldName=true values=false params={} parsedParamName=""
    label="" tooltip="" inputType="input" wrapperArgs={} inputArgs={} localeOpts={} onAddClick="" 
    containerMarkup=false entryMarkup=false namePrefixFunc=false extraArgs...>
  <#local typeName = rawString(typeName)>
  <#local paramNamePrefix = rawString(paramNamePrefix)>
  <#if entityFieldName?is_boolean>
    <#local entityFieldName = rawString(Static["org.ofbiz.entity.model.ModelUtil"].dbNameToVarName(typeName))>
  </#if>
  <#t/>
  <#if values?is_hash>
    <#local entryDataList = (values[typeName]![])>
  <#elseif values?is_sequence>
    <#local entryDataList = values>
  <#else>
    <#local values = getStcLocFieldParsedParams(params, parsedParamName, paramNamePrefix)>
    <#local entryDataList = (values[typeName]![])>
  </#if>
  <#t/>
  <#if !onAddClick?has_content>
    <#local onAddClick>stcLocFieldHandler.handleFieldAdd(this);</#local>
  </#if>
  <#if !containerMarkup?is_directive>
    <#local containerMarkup = stcLocFieldContainer>
  </#if>
  <#if !entryMarkup?is_directive>
    <#local entryMarkup = stcLocFieldEntry>
  </#if>
  <#if !namePrefixFunc?is_macro>
    <#local namePrefixFunc = makeStcLocFieldNamePrefix>
  </#if>
  <#-- FIXME: need a separate div for html data attributes due to missing @field support for this -->
  <#local dataElem><#t/>
    <div style="display:none;" class="stc-locfield-data"<#t/>
        <#t/> data-stclf-type-name="${escapeVal(typeName, 'html')}"
        <#t/> data-stclf-param-name-prefix="${escapeVal(paramNamePrefix, 'html')}"
    ></div><#t/>
  </#local>
  <#local entryArgs = {"localeOpts":localeOpts, "inputArgs":inputArgs, "inputType":inputType}>
  <@containerMarkup typeName=typeName fieldName=entityFieldName paramNamePrefix=paramNamePrefix
      onAddClick=onAddClick entryTmpl=entryMarkup extraTmpl=dataElem wrapperArgs=(wrapperArgs+{"label":label, "tooltip":tooltip})
      entryArgs=entryArgs>
    <#if entryDataList?has_content>
      <#-- add the main/default entry (Product[Category]Content, index zero) + ContentAssoc entries -->
      <#list entryDataList as entryData>
        <#local namePrefix = namePrefixFunc(paramNamePrefix, typeName, entityFieldName, entryData?index)>
        <@entryMarkup args=(entryArgs+{"entryData":entryData, "localeFieldName":(namePrefix+"localeString"), "textFieldName":(namePrefix+"textData")})/>
      </#list>
    <#else>
      <#-- add empty main/default entry (Product[Category]Content) -->
      <#local namePrefix = namePrefixFunc(paramNamePrefix, typeName, entityFieldName, 0)>
       <@entryMarkup args=(entryArgs+{"entryData":{}, "localeFieldName":(namePrefix+"localeString"), "textFieldName":(namePrefix+"textData")})/>
    </#if>
  </@containerMarkup>
</#macro>
