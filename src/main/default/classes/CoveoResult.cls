public with sharing class CoveoResult {

    public Map<String, Object> untypedResult;
    public Integer rank;
    public String title;
    public String clickUri;
    public String excerpt;
    public String rankingModifier;
    public Boolean isRecommendation;
    public Boolean isTopResult;
    public map<String, Object> raw;

    public CoveoResult() {
        this.raw = new Map<String,Object>();
    }

    public CoveoResult(Map<String, Object> untyped) {
        this.untypedResult = untyped;
        this.title = (String)this.untypedResult.get('title');
        this.excerpt = (String)this.untypedResult.get('excerpt');
        this.clickUri = (String)this.untypedResult.get('clickUri');
        this.isRecommendation = (Boolean)this.untypedResult.get('isRecommendation');
        this.isTopResult = (Boolean)this.untypedResult.get('isTopResult');
        this.raw = (Map<String,Object>)this.untypedResult.get('raw');
    }

    public Object getRawProperty(String key) {
        if(this.raw == null || this.raw.get(key) == null) {
            return '';
        } 
        return this.raw.get(key);
    }

    public DateTime getRawPropertyAsDateTime(String key) {
        try {
            return DateTime.newInstance((Long)this.raw.get(key));
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
    }

    public String getRawPropertyAsString(String key) {
        if(this.raw == null || this.raw.get(key) == null) {
            return '';
        }
        try {
            return String.valueOf(this.raw.get(key));
        } catch (Exception ex) {
            System.debug(key + ' cannot be cast as a String.');
            return '';
        }
    }

    public Boolean getRawPropertyAsBoolean(String key) {
        if(this.raw == null || this.raw.get(key) == null) {
            return null;
        }
        Object v = this.raw.get(key);
        // Try to parse as Boolean.
        if(v instanceof Boolean) return (Boolean)v;
        // Try to parse from a String.
        if(v instanceof String) return Boolean.valueOf((String)v);
    }

    public Integer getRawPropertyAsInteger(String key) {
        if(this.raw == null || this.raw.get(key) == null) {
            return null;
        }
        Object v = this.raw.get(key);
        // Try to parse as Integer.
        if(v instanceof Integer) return (Integer)v;
        // Try to parse from a String.
        if(v instanceof String) return Integer.valueOf((String)v);
    }

    public Double getRawPropertyAsDouble(String key) {
        if(this.raw == null || this.raw.get(key) == null) {
            return null;
        }
        Object v = this.raw.get(key);
        // Try to parse as Double.
        if(v instanceof Double) return (Double)v;
        // Try to parse from a String.
        if(v instanceof String) return Double.valueOf((String)v);
    }

    public Boolean deserializeFromObject(Object toDeserialize) {
        try {
            Map<String, Object> resultUntyped = (Map<String, Object>)toDeserialize;
            this.untypedResult = resultUntyped;
            this.title = (String)resultUntyped.get('title');
            this.excerpt = (String)resultUntyped.get('excerpt');
            this.clickUri = (String)resultUntyped.get('clickUri');
            this.isRecommendation = (Boolean)resultUntyped.get('isRecommendation');
            this.isTopResult = (Boolean)resultUntyped.get('isTopResult');
            this.raw = (Map<String,Object>) resultUntyped.get('raw');
            return true;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return false;
        }
    }
}
