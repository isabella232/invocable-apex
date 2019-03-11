public with sharing class CoveoInvocableSearch {

    public class CoveoChatbotSearchInput {
        @InvocableVariable(required=true)
        public String searchQuery;
    }

    public class CoveoChatbotSearchOutput {
        @InvocableVariable(required=true)
        public String results;
        @InvocableVariable(required=true)
        public Boolean hasResults;
    }

    @InvocableMethod(label='Coveo Invocable Search' description='Search Coveo with the user input.')
    public static List<CoveoChatbotSearchOutput> invokeQuerySuggest(List<CoveoChatbotSearchInput> inputs) {
        List<CoveoChatbotSearchOutput> outputs = new List<CoveoChatbotSearchOutput>();
        for(CoveoChatbotSearchInput input: inputs) {
            // Initialize the output.
            CoveoChatbotSearchOutput output = new CoveoChatbotSearchOutput();
            output.results = '';
            output.hasResults = false;

            // Create your request to Coveo SearchAPI.
            CoveoSearchAPI.Request myRequest = new CoveoSearchAPI.Request();
            myRequest.q = input.searchQuery; // You can use q, aq, cq, lq.
            myRequest.params.put('searchHub', 'mySearchHub'); // Example of search hub.
            myRequest.params.put('numberOfResults', 3); // Request only 3 search results.
            myRequest.context.put('UserRole', 'myContextValue'); // Add user context, information about the current user.

            try {
                // Use the named credentials coveoapexsearch to send an authenticated query.
                CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveoapexsearch', '{!$Credential.Password}');
                CoveoSearchAPI.Response myResponse = searchClient.executeQuery(myRequest);
                if(myResponse.totalCount > 0) { // If the search returned some results.
                    output.hasResults = true;
                    for(CoveoResult result: myResponse.results) {
                        output.results += result.title + '\n' + result.clickUri + '\n\n'; // Create a way to display results.
                    }
                }
                // Send an analytics event to Coveo
                sendSearchEvent(myResponse, input.searchQuery);
            } catch(Exception e) {
                System.debug(e);
                System.debug(e.getLineNumber());
            }
            outputs.add(output);
        }
        return outputs;
    }

    private static void sendSearchEvent(CoveoSearchAPI.Response searchResponse, String userInput) {
        CoveoAnalytics.Client analyticsClient = new CoveoAnalytics.Client('callout:coveoapexanalytics', '{!$Credential.Password}');
        CoveoAnalytics.SearchEvent searchEvent = CoveoAnalytics.SearchEvent.fromQueryResponse(searchResponse);
        searchEvent.withParam('queryText', userInput)
            .withParam('actionCause', 'chatbotSearch')
            .withParam('actionType', 'chatbot')
            .withParam('originLevel1', 'mySearchHub')
            .withParam('language', 'en')
            .withParam('originContext', 'ChatbotSearch');
        CoveoAnalytics.Response analyticsResponse = analyticsClient.logSearchEvent(searchEvent, null);
        String visitorId;
        if(analyticsResponse != null) {
            // visitorId is a code used by Coveo to make sure consecutive events are considered part of the same visit.
            visitorId = analyticsResponse.visitorId;
        }
        System.debug('VisitorId: ' + visitorId);
    }
}
