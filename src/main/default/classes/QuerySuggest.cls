public with sharing class QuerySuggest {

    private static final String PATH = 'querySuggest';

    public static String getPath() {
        return QuerySuggest.PATH;
    }

    public class Response {
        public List<QuerySuggest.Result> completions;
    }

    public class Result {
        public String expression;
        public Double score;
        public Double executableConfidence;
    }

    public class Request {
        public String partialQuery;
        public String language;
        Map<String,Object> additionalParams;

        public Request(String partialQuery, String language, Map<String,Object> additionalParams) {
            this.partialQuery = partialQuery;
            this.language = language;
            if(additionalParams == null) {
                this.additionalParams = new Map<String,Object>();
            } else {
               this.additionalParams = additionalParams;
            }
        }
    }
}
