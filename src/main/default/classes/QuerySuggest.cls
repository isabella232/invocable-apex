public with sharing class QuerySuggest {

    private static final String PATH = 'querySuggest';

    public static String getPath() {
        return QuerySuggest.PATH;
    }

    public class Response {
        public List<QuerySuggestResult> completions;
    }

    public class QuerySuggestResult {
        public String expression;
        public Double score;
        public Double executableConfidence;
    }
}
