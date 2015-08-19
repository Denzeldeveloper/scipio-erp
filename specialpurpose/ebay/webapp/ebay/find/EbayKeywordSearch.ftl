<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<div class="screenlet">
  <div class="screenlet-title-bar">
    <h3>${uiLabelMap.ProductSearchProducts}, ${uiLabelMap.ProductSearchFor}:</h3>
  </div>
  <div class="screenlet-body">
    <#list searchConstraintStrings as searchConstraintString>
      <div><a href="<@ofbizUrl>keywordsearch?removeConstraint=${searchConstraintString_index}&amp;clearSearch=N</@ofbizUrl>" class="${styles.button_default!}">X</a>${searchConstraintString}</div>
    </#list>
    <span class="label">${uiLabelMap.CommonSortedBy}:</span>${searchSortOrderString}
    <div><a href="<@ofbizUrl>advancedsearch?SEARCH_CATEGORY_ID=${(requestParameters.SEARCH_CATEGORY_ID)!}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonRefineSearch}</a></div>

    <#if !productIds?has_content>
      <div><h2>${uiLabelMap.ProductNoResultsFound}.</h2></div>
    </#if>

    <#if productIds?has_content>
      <script language="JavaScript" type="text/javascript">
        //<![CDATA[
            function toggleAll(e) {
                var cform = document.products;
                var len = cform.elements.length;
                for (var i = 0; i < len; i++) {
                    var element = cform.elements[i];
                    if (element.name == "selectResult" && element.checked != e.checked) {
                        toggle(element);
                    }
                }
            }

            function toggle(e) {
                e.checked = !e.checked;
            }
        //]]>
      </script>
      <#macro paginationPanel>
        <div class="clearfix">
          <div class="lefthalf margin-left"><input type="checkbox" name="selectAll" value="0" onclick="javascript:toggleAll(this);"/> <strong>${uiLabelMap.ProductProduct}</strong></div>
          <div class="right">
            <strong>
              <#if 0 &lt; viewIndex?int>
                <a href="<@ofbizUrl>keywordsearch/~VIEW_INDEX=${viewIndex-1}/~VIEW_SIZE=${viewSize}/~clearSearch=N/~PAGING=${paging}/~noConditionFind=${noConditionFind}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonPrevious}</a> |
              </#if>
              <#if 0 &lt; listSize?int>
                ${lowIndex+1} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}
              </#if>
              <#if highIndex?int &lt; listSize?int>
                | <a href="<@ofbizUrl>keywordsearch/~VIEW_INDEX=${viewIndex+1}/~VIEW_SIZE=${viewSize}/~clearSearch=N/~PAGING=${paging}/~noConditionFind=${noConditionFind}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonNext}</a>
              </#if>
              <#if paging == "Y">
                <a href="<@ofbizUrl>keywordsearch/~VIEW_INDEX=0/~VIEW_SIZE=99999/~clearSearch=N/~PAGING=N/~noConditionFind=${noConditionFind}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonPagingOff}</a>
              <#else>
                <a href="<@ofbizUrl>keywordsearch/~VIEW_INDEX=0/~VIEW_SIZE=${previousViewSize}/~clearSearch=N/~PAGING=Y/~noConditionFind=${noConditionFind}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonPagingOn}</a>
              </#if>
            </strong>
          </div>
        </div>
      </#macro>
      <@paginationPanel />
      <form method="post" name="products" action="">
        <fieldset>
          <input type="hidden" name="productStoreId" value="${parameters.productStoreId!}" />
          <input type="hidden" name="SEARCH_CATEGORY_ID" value="${(requestParameters.SEARCH_CATEGORY_ID)!}" />
          <table class="basic-table border-top border-bottom">
            <#assign listIndex = lowIndex />
            <#assign altRow = false />
            <#list productIds as productId>
              <#assign altRow = !altRow />
              <#assign product = delegator.findOne("Product", {"productId" : productId}, true) />
              <tr<@dataRowClassStr alt=altRow />>
                <td>
                  <input type="checkbox" name="selectResult" value="${productId}"/>
                  <a href="<@ofbizUrl>EditProduct?productId=${productId}</@ofbizUrl>" class="${styles.button_default!}">[${productId}] ${(product.internalName)!}</a>
                </td>
              </tr>
            </#list>
          </table>
        </fieldset>
      </form>
      <@paginationPanel />
    </#if>
  </div>
</div>