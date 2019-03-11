public with sharing class CoveoInvocableQuerySuggest {

    private static String QS_LANGUAGE = 'en';

    public class CoveoChatbotQuerySuggestInput {
        @InvocableVariable(required=true)
        public String partialQuery;
    }

    public class CoveoChatbotQuerySuggestOutput {
        @InvocableVariable(required=true)
        public List<String> expressions;
    }
    
    @InvocableMethod(label='Coveo Invocable Query Suggest' description='Returns a list of query completion for a partial query.')
    public static List<CoveoChatbotQuerySuggestOutput> invokeQuerySuggest(List<CoveoChatbotQuerySuggestInput> inputs) {
        List<CoveoChatbotQuerySuggestOutput> outputs = new List<CoveoChatbotQuerySuggestOutput>();
        for(CoveoChatbotQuerySuggestInput input: inputs) {
            CoveoChatbotQuerySuggestOutput output = new CoveoChatbotQuerySuggestOutput();
            // Parameters of a QuerySuggest request.
            Map<String, Object> params = new Map<String, Object> {
                'searchHub' => 'mySearchHub'
            };
            CoveoQuerySuggest.Request myRequest = new CoveoQuerySuggest.Request(input.partialQuery, QS_LANGUAGE, params);
            CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveoapexsearch', '{!$Credential.Password}');
            try {
                // Send the QuerySuggest request to Coveo.
                CoveoQuerySuggest.Response myResponse = searchClient.executeQuerySuggest(myRequest);
                // QuerySuggest returns a List of completions.
                output.expressions = new List<String>();
                for(CoveoQuerySuggest.result completion: myResponse.completions) {
                    // Add each expression to the list in the chatbot output.
                    output.expressions.add(completion.expression);
                }
            } catch (Exception ex) {
                // Log error message to system logs.
                System.debug(ex);
                System.debug(ex.getLineNumber());
            }
            outputs.add(output);
        }
        return outputs;
    }
}
