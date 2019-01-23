public with sharing class CoveoRestRequest {
    
    private static final Integer REST_PLATFORM_TIMEOUT = 60000;
    public static final String CONTENT_TYPE_APPLICATION_JSON = 'application/json; charset="UTF-8"';
    private static final String COVEO_PROD_SEARCH_ENDPOINT = 'https://platform.cloud.coveo.com/rest/search/v2';

    private static final String COVEO_PROD_ANALYTICS_ENDPOINT = 'https://usageanalytics.coveo.com/rest/v15/analytics';

    /** ================== ANALYTICS REQUEST =============== **/
    /** ==================================================== **/
    public static HttpResponse logAnalyticsEvent(String token, String path, map<String,Object> eventBody, String visitorId) {
        String uri = COVEO_PROD_ANALYTICS_ENDPOINT + '/' + path;
        String urlParams = null;
        if(String.isNotBlank(visitorId)) {
            urlParams = 'visitor=' + visitorId;
        }
        return callRestPost(uri, token, eventBody, urlParams);
    }

    /** ================== SEARCH REQUEST ================== **/
    /** ==================================================== **/
    public static HttpResponse callSearchPost(String token, map<String, Object> queryBody) {
        return callSearchPost(COVEO_PROD_SEARCH_ENDPOINT, token, querybody);
    }

    public static HttpResponse callSearchPost(String path, String token, map<String, Object> queryBody) {
        return callRestPost(COVEO_PROD_SEARCH_ENDPOINT+'/'+path, token, querybody, null);
    }

    public static HttpResponse callSearchPost(String path, String token, map<String, Object> queryBody, String urlParams) {
        return callRestPost(COVEO_PROD_SEARCH_ENDPOINT+'/'+path, token, querybody, urlParams);
    }
    
    public static HttpResponse callRestPost(String uri, String token, map<String, Object> requestBody, String urlParams) {
        HttpRequest request = new HttpRequest();
        if(urlParams != null) {
            uri += '?' + urlParams;
        }
        request.setEndpoint(uri);
        request.setMethod('POST');
        request.setHeader('Accept', CONTENT_TYPE_APPLICATION_JSON);
        request.setHeader('Content-Type', CONTENT_TYPE_APPLICATION_JSON);
        request.setHeader('Authorization', 'Bearer ' + token);
        if(requestBody != null) {
            System.debug(JSON.serialize(requestBody));
            request.setBody(JSON.serialize(requestBody));
        }
        request.setTimeout(REST_PLATFORM_TIMEOUT);

        // Send the request to Coveo search api.
        Http http = new Http();
        HTTPResponse httpResponse = http.send(request);
        checkResponseForErrors(httpResponse);
        return httpResponse;
    }

    private static void checkResponseForErrors(HttpResponse response) {
        Integer statusCode = response.getStatusCode();
        if (statusCode < 200 || statusCode >= 300) {
            CalloutException e = new CalloutException();
            try {
                e.setMessage(response.getBody());
            } catch(JSONException ex) {
                e.setMessage('Status code: ' + statusCode);
            }
            throw e;
        }
    }
}
