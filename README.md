# Deprecation notice

This package still works but will receive no further updates. It was deprecated in favor of using the following classes that are now part of the [Coveo for Salesforce AppExchange package](https://url.coveo.com/appexchangelisting).

## Documentation

The documentation for the class necessary to [send a query](https://docs.coveo.com/en/2988#executequery) or to [get query suggestions](https://docs.coveo.com/en/2988#querysuggest) can be found [here](https://docs.coveo.com/en/2988).

The documentation on how to use these classes to send usage analytics events can be found [here](https://docs.coveo.com/en/3118).

You would now use these classes in your own InvocableApex actions to interact with an Einstein bot for example.

# Packaged Apex classes to use Coveo APIs

These were created to facilitate the use of Coveo APIs (SearchAPI and UsageAnalytics) from Apex.

## To install 

[Install this package in a production environment](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6A000003OkSUQA0)

[Install this package in a sandbox environment](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t6A000003OkSUQA0)

## Using this project in an Einstein chatbot

In the `src/main/default/classes/` folder of this project there are two examples classes.

- CoveoInvocableQuerySuggest
- CoveoInvocableSearch

These two classes are examples of how to use this repository in the context of Salesforce invocable Apex.
For example, these would allow you to invoke the Coveo Query Suggest API and the Coveo Search API.
In the Coveo Search API example, there is also a section on sending analytics.

**Remember that to use these classes within an Einstein bot, you need to authorize them in the permission set**

# How to use as a library

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
CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveoapexsearch', '{!$Credential.Password}');
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
CoveoSearch.Client searchClient = new CoveoSearch.Client('callout:coveoapexsearch', '{!$Credential.Password}');
CoveoSearchAPI.Response myResponse = searchClient.executeQuery(myRequest);
System.debug(JSON.serialize(myResponse));
```

## CoveoAnalytics

Namespace class that contains a Client to send UsageAnalytics events to Coveo.

### Usage example

This is an example used to log a search event using a previously executed search query to create the event.

```Java
CoveoAnalytics.Client analyticsClient = new CoveoAnalytics.Client('callout:coveoapexanalytics', '{!$Credential.Password}');
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
CoveoAnalytics.Client analyticsClientClick = new CoveoAnalytics.Client('callout:coveoapexanalytics', '{!$Credential.Password}');
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
CoveoAnalytics.Client analyticsClientCustom = new CoveoAnalytics.Client('callout:coveoapexanalytics', '{!$Credential.Password}');
CoveoAnalytics.CustomEvent customEvent = new CoveoAnalytics.CustomEvent('myEventType', 'myEventValue', 'language');
customEvent.withParam('originLevel1', 'mySearchHub')
    .withCustomData('customDimension', 'myCustomValue');
CoveoAnalytics.Response customResponse = analyticsClientCustom.logCustomEvent(customEvent, visitorId);
```


## Named Credentials

This project recommends using (named credentials)[https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_named_credentials.htm] to call the Coveo Rest endpoints.
There are two named credentials packaged with this project.

You should edit these two named credentials and enter a (Coveo API)[https://docs.coveo.com/en/105/cloud-v2-developers/api-key-authentication#passing-the-api-key-in-the-header] key as the password for these.
This mechanic will ensure the Authentication header is handled correctly and will also take care of the remote site settings for you.

Keep in mind this means all of the calls will be considered anonymous (which is a good thing for a chatbot for example).

#
The first one `coveoapexanalytics` is the named credential to call the coveo analytics endpoint.

https://usageanalytics.coveo.com/docs/write/#/Analytics_API_-_Version_15

The minimal required privileges for this (API key)[https://docs.coveo.com/en/1718/cloud-v2-administrators/manage-api-keys#add-an-api-key] are : 
    
    - Analytics > Analytics data: `Push`

# 
The second one `coveoapexsearch` is the named credential to call the coveo search endpoint.

https://platform.cloud.coveo.com/docs?api=SearchApi#/

The minimal required privileges for this (API key)[https://docs.coveo.com/en/1718/cloud-v2-administrators/manage-api-keys#add-an-api-key] are : 

    - Search > Execute query: `Allowed`
