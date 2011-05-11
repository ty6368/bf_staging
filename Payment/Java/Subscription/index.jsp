<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*"%>
<%@ page import="org.json.*"%>
<%
String accessToken = request.getParameter("access_token");
if(accessToken==null || accessToken=="null"){
	accessToken = (String) session.getAttribute("accessToken");}
if(accessToken==null || accessToken=="null") {
	accessToken = "";
	session.setAttribute("postOauth", "index.jsp");
	%><a href="oauth.jsp">Authenticate first</a><br><br><%
}
String amount = request.getParameter("amount");
String autoCommit = request.getParameter("autoCommit");
String category = request.getParameter("category");
String channel = request.getParameter("channel");
String currency = request.getParameter("currency");
String description = request.getParameter("description");
String extTrxID = request.getParameter("extTrxID");
String appID = request.getParameter("appID");
String cancelUrl = request.getParameter("cancelUrl");
String fulfillUrl = request.getParameter("fulfillUrl");
String productID = request.getParameter("productID");
String purchaseNoSub = request.getParameter("purchaseNoSub");
String statusUrl = request.getParameter("statusUrl");
String merchantSubscriptionIdList = request.getParameter("merchantSubscriptionIdList");
if(merchantSubscriptionIdList==null || merchantSubscriptionIdList=="null") {
	merchantSubscriptionIdList = (String) session.getAttribute("merchantSubscriptionIdList");}
if(merchantSubscriptionIdList==null || merchantSubscriptionIdList=="null") {
	merchantSubscriptionIdList = ""; }
String subscriptionRecurringNumber = request.getParameter("subscriptionRecurringNumber");
String subscriptionRecurringPeriod = request.getParameter("subscriptionRecurringPeriod");
String subscriptionRecurringPeriodAmount = request.getParameter("subscriptionRecurringPeriodAmount");
String trxID = (String) session.getAttribute("trxID");
if(trxID==null || trxID=="null")
trxID = "";
String newSubscription = request.getParameter("newSubscription");
String getSubscriptionDetails = request.getParameter("getSubscriptionDetails");
String responseFormat = request.getParameter("responseFormat");
String print = "";
%>

<form name="newSubscripion" method="post">
Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
Amount <input type="text" name="amount" value="0.05" /><br />
Auto Commit <input type="text" name="autoCommit" value="false" /><br />
Category <input type="text" name="category" value="1" /><br />
Channel <input type="text" name="channel" value="MOBILE_WEB" /><br />
Currency <input type="text" name="currency" value="USD" /><br />
Description <input type="text" name="description" value="ProductByMe" /><br />
Transaction ID <input type="text" name="extTrxID" value="Transaction151" /><br />
App ID <input type="text" name="appID" value="" /><br />
Cancel Redirect Url <input type="text" name="cancelUrl" value="http://localhost:8080/Subscription/index.jsp" size=40/><br />
Fulfillment Url <input type="text" name="fulfillUrl" value="http://localhost:8080/Subscription/index.jsp" size=40/><br />
Product ID <input type="text" name="productID" value="Product252" /><br />
PurhcaseOnNoActiveSubscription <input type="text" name="purchaseNoSub" value="false" /><br />
Status Url <input type="text" name="statusUrl" value="http://localhost:8080/Subscription/index.jsp" size=40/><br />
Merchant Subscription ID List <input type="text" name="merchantSubscriptionIdList" value="MySubscription3" /><br />
Subscription Recurring Number <input type="text" name="subscriptionRecurringNumber" value="3" /><br />
Subscription Recurring Period <input type="text" name="subscriptionRecurringPeriod" value="MONTHLY" /><br />
Subscription Recurring Period Amount <input type="text" name="subscriptionRecurringPeriodAmount" value="1" /><br />
<input type="submit" name="newSubscription" value="Click to make new subscription" />
</form><br>

<%  
if(newSubscription!=null) {
    String url ="https://beta-api.att.com/1/payments/transactions";   
    HttpClient client = new HttpClient();
    PostMethod method = new PostMethod(url);  
    method.setQueryString("access_token=" + accessToken);
    method.addRequestHeader("Content-Type","application/json");
    method.addRequestHeader("Accept","application/json");
    JSONObject bodyObject = new JSONObject();
    bodyObject.put("amount",Double.parseDouble(amount));
    bodyObject.put("autoCommit",Boolean.parseBoolean(autoCommit));
    bodyObject.put("category",category);
    bodyObject.put("channel",channel);
    bodyObject.put("currency",currency);
    bodyObject.put("description",description);
    bodyObject.put("externalMerchantTransactionID",extTrxID);
    bodyObject.put("merchantApplicationID",appID);
    bodyObject.put("merchantCancelRedirectUrl",cancelUrl);
    bodyObject.put("merchantFulfillmentRedirectUrl",fulfillUrl);
    bodyObject.put("merchantProductID",productID);
    bodyObject.put("purchaseOnNoActiveSubscription",Boolean.parseBoolean(purchaseNoSub));
    bodyObject.put("transactionStatusCallbackUrl",statusUrl);
    bodyObject.put("merchantSubscriptionIdList",merchantSubscriptionIdList);
    session.setAttribute("merchantSubscriptionIdList",merchantSubscriptionIdList);
    bodyObject.put("subscriptionRecurringNumber",Double.parseDouble(subscriptionRecurringNumber));
    bodyObject.put("subscriptionRecurringPeriod",subscriptionRecurringPeriod);
    bodyObject.put("subscriptionRecurringPeriodAmount",Double.parseDouble(subscriptionRecurringPeriodAmount));
    method.setRequestBody(bodyObject.toString()); 
    int statusCode = client.executeMethod(method);   
   // System.out.println(method.getResponseBodyAsString());
    if(statusCode==200) {
    	JSONObject rpcObject = new JSONObject(method.getResponseBodyAsString());
    	response.sendRedirect(rpcObject.getString("redirectUrl"));
    	session.setAttribute("trxID", rpcObject.getString("trxID"));
    } else {
    	print = method.getResponseBodyAsString();
    }
    method.releaseConnection();
}
%> 

<form name="getSubscriptionDetails" action="" method="get">
	Subscription ID <input type="text" name="merchantSubscriptionIdList" value="<%=merchantSubscriptionIdList%>" size=40/><br />
	Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
	Response Format: <input type="radio" name="responseFormat" value="xml">XML<input type="radio" name="responseFormat" value="json" checked>JSON<br/>
	<input type="submit" name="getSubscriptionDetails" value="Get Subscription Details" />
</form><br>

   <%  
       if(getSubscriptionDetails!=null) {
           String url ="https://beta-api.att.com/1/payments/subscriptions/" + merchantSubscriptionIdList;   
           HttpClient client = new HttpClient();
           GetMethod method = new GetMethod(url);  
           method.setQueryString("access_token=" + accessToken);
           method.addRequestHeader("Accept","application/" + responseFormat);
           int statusCode = client.executeMethod(method);    
           print = method.getResponseBodyAsString();
         //  System.out.println(method.getResponseBodyAsString());
           method.releaseConnection();
       }
   %>

<br><br><html><body><%=print%></body></html>