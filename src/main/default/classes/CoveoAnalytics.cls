public with sharing class CoveoAnalytics {

    private static final String COVEO_ANALYTICS_SEARCH_PATH = 'search';
    private static final String COVEO_ANALYTICS_CLICK_PATH = 'click';
    private static final String COVEO_ANALYTICS_CUSTOM_PATH = 'custom';

    private enum EventTypes {SEARCH, CLICK, CUSTOM}

    public class AnalyticsException extends Exception{}

    public virtual class Event {
        public Map<String,Object> params{get; set;}

        public Event() {
            this.params = new Map<String,Object>();
        }

        public Event withParam(String key, Object value) {
            this.params.put(key, value);
            return this;
        }

        public Event withCustomData(String key, Object value) {
            Map<String, Object> newCustomData;
            if(this.params.get('customData') != null) {
                newCustomData = new Map<String, Object>((Map<String,Object>)this.params.get('customData'));
            } else {
                newCustomData = new Map<String, Object>();
            }
            newCustomData.put(key, value);
            this.params.put('customData', newCustomData);
            return this;
        }

        public String stringify() {
            return JSON.serialize(this.params);
        }
    }

    public class SearchEvent extends Event {
        public static SearchEvent fromQueryResponse(CoveoSearchAPI.Response queryResponse) {
            if(queryResponse != null) {
                SearchEvent myEvent = new SearchEvent();
                myEvent
                    .withParam('numberOfResults', queryResponse.totalCount)
                    .withParam('responseTime', queryResponse.duration)
                    .withParam('searchQueryUid', queryResponse.searchUid);
                return myEvent;
            } else {
                throw new AnalyticsException('Cannot create search event from a null query');
            }
        }
    }

    public class ClickEvent extends Event {
        public static ClickEvent fromSearchAPIResult(CoveoResult result) {
            if(result != null) {
                ClickEvent myEvent = new ClickEvent();
                if(String.isNotEmpty((String)result.getRawProperty('permanentid'))) {
                    myEvent.withCustomData('contentIDKey', 'permanentid')
                        .withCustomData('contentIDValue', result.getRawProperty('permanentid'));
                }
                myEvent.withCustomData('documentTitle', result.title)
                    .withCustomData('documentURL', result.clickUri)
                    .withParam('documentPosition', result.rank+1) // clickRank is 1 based.
                    .withParam('documentTitle', result.title)
                    .withParam('documentUri', result.clickUri)
                    .withParam('documentUrl', result.clickUri)
                    .withParam('documentUriHash', result.getRawProperty('urihash'))
                    .withParam('sourceName', result.getRawProperty('source'))
                    .withParam('rankingModifier', result.rankingModifier);
                return myEvent;
            } else {
                throw new AnalyticsException('Cannot create click event from a null query');
            }
        }
    }

    public class CustomEvent extends Event {
        public String eventType;
        public String eventValue;
        public String language;

        public CustomEvent(String eventType, String eventValue, String language) {
            this.withParam('eventType', eventType);
            this.withParam('eventValue', eventValue);
            this.withParam('language', language);
        }
    }

    public class Response {
        public String visitId;
        public String visitorId;
    }
    
    public static CoveoAnalytics.Response logSearchEvent(String token, CoveoAnalytics.SearchEvent event, String visitorId) {
        return logEvent(token, event, visitorId, COVEO_ANALYTICS_SEARCH_PATH);
    }
    public static CoveoAnalytics.Response logClickEvent(String token, CoveoAnalytics.ClickEvent event, String visitorId) {
        return logEvent(token, event, visitorId, COVEO_ANALYTICS_CLICK_PATH);
    }
    public static CoveoAnalytics.Response logCustomEvent(String token, CoveoAnalytics.CustomEvent event, String visitorId) {
        return logEvent(token, event, visitorId, COVEO_ANALYTICS_CUSTOM_PATH);
    }

    private static CoveoAnalytics.Response logEvent(String token, CoveoAnalytics.Event event, String visitorId, String path) {
        try {
            HttpResponse analyticsResponse = CoveoRestRequest.logAnalyticsEvent(token, path, event.params, visitorId);
            if(analyticsResponse != null && analyticsResponse.getStatusCode() == 200) { // Everything worked correctly.
                CoveoAnalytics.Response response = (CoveoAnalytics.Response) JSON.deserialize(analyticsResponse.getBody(), CoveoAnalytics.Response.class);
                return response;
            } else {
                return null;
            }
        }  catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
}
