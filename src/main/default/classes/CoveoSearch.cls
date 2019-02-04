public with sharing class CoveoSearch {

    public static final String COVEO_PROD_SEARCH_ENDPOINT = 'https://platform.cloud.coveo.com/rest/search/v2';
    private static final String COVEO_QUERY_SUGGEST_PATH = 'querySuggest';

    public class Client {
        public String endpoint;
        public String token;

        public Client() {
            this.endpoint = COVEO_PROD_SEARCH_ENDPOINT;
            this.token = '';
        }

        public Client(String endpoint, String token) {
            this.endpoint = endpoint;
            this.token = token;
        }

        public CoveoQuerySuggest.Response executeQuerySuggest(CoveoQuerySuggest.Request qsRequest) {
            try {
                HttpResponse querySuggestHttpResponse = CoveoRestRequest.callSearchPost(
                    this.endpoint + '/' + COVEO_QUERY_SUGGEST_PATH, 
                    this.token, 
                    qsRequest.build()
                );

                if(querySuggestHttpResponse.getStatusCode() == 200) { // Everything worked correctly.
                    CoveoQuerySuggest.Response response = (CoveoQuerySuggest.Response) JSON.deserialize(
                        querySuggestHttpResponse.getBody(), 
                        CoveoQuerySuggest.Response.class
                    );
                    return response;
                } else {
                    return null;
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
                return null;
            }
        }

        public CoveoSearchAPI.Response executeQuery(CoveoSearchAPI.Request mySearchRequest) {
            if(mySearchRequest == null) return null;
            try {
                // Add user context.
                mySearchRequest.build();

                HttpResponse coveoSearchHttpResponse = CoveoRestRequest.callSearchPost(this.endpoint, this.token, mySearchRequest.params);

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
    

}
