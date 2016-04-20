/*******************************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/
package com.ilscipio.cato.ce.webapp.ftl.template;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.ilscipio.cato.ce.webapp.ftl.lang.LangFtlUtil;

import freemarker.template.ObjectWrapper;
import freemarker.template.SimpleSequence;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModelException;
import freemarker.template.TemplateScalarModel;

/**
 * Cato: GetStyleNamesByPrefix - Freemarker Method for extracting style names by prefix from a style string.
 */
public class GetStyleNamesByPrefix implements TemplateMethodModelEx {

    public static final String module = GetStyleNamesByPrefix.class.getName();

    /*
     * @see freemarker.template.TemplateMethodModel#exec(java.util.List)
     */
    @SuppressWarnings("unchecked")
    @Override
    public Object exec(List args) throws TemplateModelException {
        if (args == null || args.size() != 2) {
            throw new TemplateModelException("Invalid number of arguments (expected: 2)");
        }
        // NOTE: getAsString triggers auto-escaping, this is okay here
        String styleString = ((TemplateScalarModel) args.get(0)).getAsString();
        styleString = TemplateFtlUtil.getPlainClassArgNames(styleString);
        
        // NOTE: getAsString triggers auto-escaping, this is okay here
        String prefix = ((TemplateScalarModel) args.get(1)).getAsString();
        
        String[] names = StringUtils.split(styleString, ' ');
        // NonEscaping: needed because getAsString above already escapes string through EscapingObjectWrapper
        ObjectWrapper objectWrapper = LangFtlUtil.getNonEscapingObjectWrapper();
        SimpleSequence res = new SimpleSequence(names.length, objectWrapper);

        for(String name : names) {
            if (name.startsWith(prefix)) {
                res.add(name);
            }
        }
        
        return res;
    }

}
