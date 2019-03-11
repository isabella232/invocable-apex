public with sharing class CoveoSearchAPI {

    public class Response {
        public Map<String, Object> untyped;
        public Integer duration;
        public String searchUid;
        public String pipeline;
        public List<Object> rawResults;
        public List<CoveoResult> results;
        public Integer totalCount;

        public Response(){}

        public Response(Map<String,Object> untyped) {
            this.untyped = untyped;
            this.duration = (Integer)this.untyped.get('duration');
            this.searchUid = (String)this.untyped.get('searchUid');
            this.pipeline = (String)this.untyped.get('pipeline');
            this.totalCount = (Integer)this.untyped.get('totalCount');
            this.rawResults = (List<Object>)this.untyped.get('results');
            this.deserializeResultsTyped();
        }

        public void deserializeResultsTyped() {
            if(this.rawResults != null && !this.rawResults.isEmpty()) {
                this.results = new List<CoveoResult>();
                Integer rank = 0;
                for(Object resultUntyped: this.rawResults) {
                    CoveoResult result = new CoveoResult();
                    if(result.deserializeFromObject(resultUntyped)) {
                        result.rank = rank;
                        this.results.add(result);
                    }
                    rank++;
                }
            }
        }
    }

    public class Request {
        public String q;
        public String aq;
        public String cq;
        public String lq;
        public Map<String,Object> params;
        public Map<String,Object> context;

        public Request() {
            this.params = new Map<String,Object>();
            this.context = new Map<String,Object>();
        }

        public void build() {
            if(this.params == null) this.params = new Map<String,Object>();
            if(this.q != null) this.params.put('q', this.q);
            if(this.aq != null) this.params.put('aq', this.aq);
            if(this.cq != null) this.params.put('cq', this.cq);
            if(this.lq != null) this.params.put('lq', this.lq);
            if(this.context != null) this.params.put('context', context);
        }
    }
}
