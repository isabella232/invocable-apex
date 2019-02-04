# Packaged Apex classes to use Coveo APIs

These were created to faciliate the use of Coveo APIs (SearchAPI and UsageAnalytics) from Apex.
There are two main classes:

## CoveoSearch

This is a "namespace" class to contain the CoveoSearch.Client to send search and querysuggest requests to Coveo.

### Usage example:

This is using the namedCredentials feature of Salesforce.
This is an example of QuerySuggest
```Java
Map<String, Object> params = new Map<String, Object> {
    'searchHub' => 'mySearchHub'
};
CoveoQuerySuggest.Request myRequest = new CoveoQuerySuggest.Request('my partial query', 'en', params);
CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveosearchprod', '{!$Credential.Password}');
CoveoQuerySuggest.Response myResponse = searchClient.executeQuerySuggest(myRequest);
System.debug(JSON.serialize(myResponse));
System.debug(myResponse.completions.get(0).expression);
```

This is an example of sending a search query:
```Java
String userInput = 'something the user typed';
CoveoSearchAPI.Request myRequest = new CoveoSearchAPI.Request();
myRequest.q = userInput; // You can use q, aq, cq, lq.
myRequest.params.put('searchHub', 'mySearchHub');
myRequest.context.put('UserRole', 'myContextValue');
CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveosearchprod', '{!$Credential.Password}');
CoveoSearchAPI.Response myResponse = searchClient.executeQuery(myRequest);
System.debug(JSON.serialize(myResponse));
```

## CoveoAnalytics

Namespace class that contains a Client to send UsageAnalytics events to Coveo.

### Usage example

This is an example used to log a search event using a previously executed search query to create the event.

```Java
CoveoAnalytics.Client analyticsClient = new CoveoAnalytics.Client('callout:coveoanalyticsprod', '{!$Credential.Password}');
CoveoAnalytics.SearchEvent searchEvent = CoveoAnalytics.SearchEvent.fromQueryResponse(myResponse);
searchEvent.withParam('queryText', userInput)
    .withParam('actionCause', 'chatbotSearch')
    .withParam('actionType', 'chatbot')
    .withParam('originLevel1', 'mySearchHub')
    .withParam('language', 'en')
    .withParam('originContext', 'CommunitySearch');
CoveoAnalytics.Response analyticsResponse = analyticsClient.logSearchEvent(searchEvent, null);
String visitorId;
if(analyticsResponse != null) {
    visitorId = analyticsResponse.visitorId;
}
System.debug('VisitorId: ' + visitorId);
```

This is an example of logging a click event created from a CoveoResult:
``` Java
CoveoAnalytics.Client analyticsClientClick = new CoveoAnalytics.Client('callout:coveoanalyticsprod', '{!$Credential.Password}');
CoveoAnalytics.ClickEvent clickEvent = CoveoAnalytics.ClickEvent.fromCoveoResult(myResponse.results.get(0));
clickEvent.withParam('actionCause', 'documentOpen')
    .withParam('actionType', 'document')
    .withParam('originLevel1', 'mySearchHub')
    .withParam('language', 'en')
    .withParam('searchQueryUid', myResponse.searchUid)
    .withParam('originContext', 'CommunitySearch');
CoveoAnalytics.Response clickResponse = analyticsClientClick.logClickEvent(clickEvent, visitorId);
```

This is an example of logging a custom event:
```Java
CoveoAnalytics.Client analyticsClientCustom = new CoveoAnalytics.Client('callout:coveoanalyticsprod', '{!$Credential.Password}');
CoveoAnalytics.CustomEvent customEvent = new CoveoAnalytics.CustomEvent('myEventType', 'myEventValue', 'language');
customEvent.withParam('originLevel1', 'mySearchHub')
    .withCustomData('customDimension', 'myCustomValue');
CoveoAnalytics.Response customResponse = analyticsClientCustom.logCustomEvent(customEvent, visitorId);
```


## Named Credentials