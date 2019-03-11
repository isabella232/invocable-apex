public with sharing class CoveoQuerySuggest {

    private static final String PATH = 'querySuggest';

    public static String getPath() {
        return CoveoQuerySuggest.PATH;
    }

    public class Response {
        public List<CoveoQuerySuggest.Result> completions;
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

        public Map<String,Object> build() {
            if(this.additionalParams == null) {
                this.additionalParams = new Map<String,Object>();
            }
            if(this.partialQuery != null) {
                this.additionalParams.put('q', this.partialQuery);
            }
            if(this.language != null) {
                this.additionalParams.put('language', this.language);
            }
            return this.additionalParams;
        }
    }
}
