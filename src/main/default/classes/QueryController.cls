public with sharing class QueryController {

    public static QuerySuggest.Response executeQuerySuggest(QuerySuggest.Request requestParams, String token) {
        try {
            // Add the query to the additional raw params.
            additionalParams.put('q', requestParams.partialQuery);
            additionalParams.put('language', requestParams.language);

            HttpResponse querySuggestHttpResponse = CoveoRestRequest.callSearchPost(QuerySuggest.getPath(), token, requestParams.additionalParams);

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

    public static CoveoSearchAPI.Response executeQuery(CoveoSearchAPI.Request mySearchRequest, String token) {
        if(mySearchRequest == null) return null;
        try {
            // Add user context.
            mySearchRequest.build();

            HttpResponse coveoSearchHttpResponse = CoveoRestRequest.callSearchPost(CoveoSearchAPI.getPath(), token, mySearchRequest.params);

            if(coveoSearchHttpResponse.getStatusCode() == 200) { // Everything worked correctly.
                CoveoSearchAPI.Response response = new CoveoSearchAPI.Response((Map<String,Object>) JSON.deserializeUntyped(coveoSearchHttpResponse.getBody()));
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
