public with sharing class QueryController {

    public static QuerySuggest.Response executeQuerySuggest(String query, String language, Map<String,Object> additionalParams, String token) {
        try {
            // Add the query to the additional raw params.
            additionalParams.put('q', query);
            additionalParams.put('language', language);

            HttpResponse querySuggestHttpResponse = CoveoRestRequest.callSearchPost(QuerySuggest.getPath(), token, additionalParams);

            if(querySuggestHttpResponse.getStatusCode() == 200) { // Everything worked correctly.
                QuerySuggest.Response response = (QuerySuggest.Response) JSON.deserialize(querySuggestHttpResponse.getBody(), QuerySuggest.Response.class);
                return response;
            } else {
                return null;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    public static CoveoSearch.Response executeQuery(String query, Map<String,Object> additionalParams, String token, Map<String,Object> context) {
        try {
            // Add the query to the additional raw params.
            additionalParams.put('q', query);
            // Add user context.
            if(context != null) {
                additionalParams.put('context', context);
            }

            HttpResponse coveoSearchHttpResponse = CoveoRestRequest.callSearchPost(CoveoSearch.getPath(), token, additionalParams);

            if(coveoSearchHttpResponse.getStatusCode() == 200) { // Everything worked correctly.
                CoveoSearch.Response response = new CoveoSearch.Response((Map<String,Object>) JSON.deserializeUntyped(coveoSearchHttpResponse.getBody()));
                return response;
            } else {
                return null;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
}
