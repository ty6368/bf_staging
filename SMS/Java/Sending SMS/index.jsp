<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*"%>
<%
	String accessToken = request.getParameter("access_token");
	if(accessToken==null || accessToken=="null"){
		accessToken = (String) session.getAttribute("accessToken");}
	if(accessToken==null || accessToken=="null") {
		accessToken = "";
		session.setAttribute("postOauth", "index.jsp");
		%><a href="oauth.jsp">Authenticate first</a><br><br><%
	}
	String address = request.getParameter("address");
	String message = request.getParameter("message");
	String smsId = (String) session.getAttribute("smsId");
	if(smsId==null) smsId = "";
	String responseFormat = request.getParameter("responseFormat");
	String getSmsDeliveryStatus = request.getParameter("getSmsDeliveryStatus");
	String sendSms = request.getParameter("sendSms");
	String print = "";
%> <br>


<form name="sendSms" method="post">
	Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
	MSISDN <input type="text" name="address" value="tel:" /><br />
	Message <input type="text" name="message" value="Test." size=40/><br />
	Response Format: <input type="radio" name="responseFormat" value="xml">XML<input type="radio" name="responseFormat" value="json" checked>JSON<br/>
	<input type="submit" name="sendSms" value="Send SMS"/>
</form><br>

   <%   
       if(sendSms!=null) {
           String url ="https://beta-api.att.com/1/messages/outbox/sms";   
           HttpClient client = new HttpClient();
           PostMethod method = new PostMethod(url);  
           NameValuePair nvp2= new NameValuePair("message",message);
           NameValuePair nvp3= new NameValuePair("address",address);
   	   method.setRequestBody(new NameValuePair[]{nvp2,nvp3}); 
           method.setQueryString("access_token=" + accessToken);
           method.addRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8");
           method.addRequestHeader("Accept","application/" + responseFormat);
           int statusCode = client.executeMethod(method); 
           if(statusCode==201) {
           	if(responseFormat.equalsIgnoreCase("json")) smsId = method.getResponseBodyAsString().substring(9,28);
           	else if(responseFormat.equalsIgnoreCase("xml")) smsId = method.getResponseBodyAsString().substring(47);
           	session.setAttribute("smsId", smsId);
           }
           print = method.getResponseBodyAsString();
           method.releaseConnection();
       }
   %>   

<form name="getSmsDeliveryStatus" action="" method="get">
	Request Identifier <input type="text" name="id" value="<%=smsId%>" size=40/><br />
	Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
	Response Format: <input type="radio" name="responseFormat" value="xml">XML<input type="radio" name="responseFormat" value="json" checked>JSON<br/>
	<input type="submit" name="getSmsDeliveryStatus" value="Get SMS Delivery Status" />
</form>

   <%  
       if(getSmsDeliveryStatus!=null) {
           String url ="https://beta-api.att.com/1/messages/outbox/sms/" + smsId;   
           HttpClient client = new HttpClient();
           GetMethod method = new GetMethod(url);  
           method.setQueryString("access_token=" + accessToken + "&id=" + smsId);
           method.addRequestHeader("Accept","application/" + responseFormat);
           int statusCode = client.executeMethod(method);    
           print = method.getResponseBodyAsString();
           System.out.println(method.getResponseBodyAsString());
           method.releaseConnection();
       }
   %>     

<br><br><html><body><%=print%></body></html>