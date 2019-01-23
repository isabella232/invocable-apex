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

    public CoveoResult() {}

    public CoveoResult(Map<String, Object> untyped) {
        this.untypedResult = untyped;
        this.title = (String)this.untypedResult.get('title');
        this.excerpt = (String)this.untypedResult.get('excerpt');
        this.clickUri = (String)this.untypedResult.get('clickUri');
        this.isRecommendation = (Boolean)this.untypedResult.get('isRecommendation');
        this.isTopResult = (Boolean)this.untypedResult.get('isTopResult');
        this.raw = (Map<String,Object>)this.untypedResult.get('raw');
    }

    public Object getRawProperty(String name) {
        if(this.raw == null || this.raw.get(name) == null) {
            return '';
        } 
        return this.raw.get(name);
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
