package org.ofbiz.base.util.collections;

import java.io.Serializable;
import java.util.Map;

import org.ofbiz.base.util.string.FlexibleStringExpander;
import org.w3c.dom.Element;

/**
 * SCIPIO: This is a simple switch between FlexibleMapAccessor and
 * FLexibleStringExpander.
 */
@SuppressWarnings("serial")
public abstract class FlexibleSwitchAccessor implements Serializable {
    
    public static final String module = FlexibleSwitchAccessor.class.getName();

    public static FlexibleSwitchAccessor getInstance(Element element, String fieldAttrName, String valueAttrName) {
        FlexibleMapAccessor<Object> fieldAccessor = null;
        FlexibleStringExpander valueExpander = null;
        
        String fieldVal = element.getAttribute(fieldAttrName);
        if (!fieldVal.isEmpty()) {
            fieldAccessor = FlexibleMapAccessor.getInstance(fieldVal);
        }
        String valueVal = element.getAttribute(valueAttrName);
        if (!valueVal.isEmpty()) {
            valueExpander = FlexibleStringExpander.getInstance(valueVal);
        }
        return getInstance(fieldAccessor, valueExpander);
    }
    
    public static FlexibleSwitchAccessor getInstance(FlexibleMapAccessor<Object> fieldAccessor, 
            FlexibleStringExpander valueExpander) {
        if (fieldAccessor != null && valueExpander != null) {
            throw new IllegalArgumentException("both field and value accessors cannot be specified at once");
        }
        if (fieldAccessor != null) {
            return new FieldAccessor(fieldAccessor);
        } else if (valueExpander != null) {
            return new ExpanderAccessor(valueExpander);
        } else {
            throw new IllegalArgumentException("no field or value accessor was specified");
        }
    }
    
    public abstract Object getValue(Map<String, Object> context);
    
    public static class FieldAccessor extends FlexibleSwitchAccessor {
        
        protected final FlexibleMapAccessor<Object> fieldAcsr;

        public FieldAccessor(FlexibleMapAccessor<Object> fieldAcsr) {
            this.fieldAcsr = fieldAcsr;
        }

        public Object getValue(Map<String, Object> context) {
            return fieldAcsr.get(context);
        }
    }
    
    public static class ExpanderAccessor extends FlexibleSwitchAccessor {
        protected final FlexibleStringExpander valueExdr;
        
        public ExpanderAccessor(FlexibleStringExpander valueExdr) {
            this.valueExdr = valueExdr;
        }

        public Object getValue(Map<String, Object> context) {
            return valueExdr.expandString(context);
        }
    }
}