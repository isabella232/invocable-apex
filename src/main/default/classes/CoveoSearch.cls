public with sharing class CoveoSearch {
    private static final String PATH = '';

    public static String getPath() {
        return CoveoSearch.PATH;
    }

    public class Response {
        public Map<String, Object> untyped;
        public Integer duration;
        public String searchUid;
        public String pipeline;
        public List<Object> rawResults;
        public List<CoveoResult> searchResults;
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
                this.searchResults = new List<CoveoResult>();
                Integer rank = 0;
                for(Object resultUntyped: this.rawResults) {
                    CoveoResult result = new CoveoResult();
                    if(result.deserializeFromObject(resultUntyped)) {
                        result.rank = rank;
                        this.searchResults.add(result);
                    }
                    rank++;
                }
            }
        }
    }
}
