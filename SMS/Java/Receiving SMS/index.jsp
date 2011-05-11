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
	String responseFormat = request.getParameter("responseFormat");
	String getReceivedSms = request.getParameter("getReceivedSms");
	String registrationID = request.getParameter("registrationID");
	String print = "";
%> <br>

<form name="getReceivedSms" action="" method="get">
	Registration ID <input type="text" name="registrationID" value="" size=40/><br />
	Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
	Response Format: <input type="radio" name="responseFormat" value="xml">XML<input type="radio" name="responseFormat" value="json" checked>JSON<br/>
	<input type="submit" name="getReceivedSms" value="Get Received Sms" />
</form>

   <%  
       if(getReceivedSms!=null) {
           String url ="https://beta-api.att.com/1/messages/inbox/sms";   
           HttpClient client = new HttpClient();
           GetMethod method = new GetMethod(url);  
           method.setQueryString("access_token=" + accessToken + "&registrationID=" + registrationID);
           method.addRequestHeader("Accept","application/" + responseFormat);
           int statusCode = client.executeMethod(method);    
           print = method.getResponseBodyAsString();
           System.out.println(method.getResponseBodyAsString());
           method.releaseConnection();
       }
   %>   

<br><br><html><body><%=print%></body></html>