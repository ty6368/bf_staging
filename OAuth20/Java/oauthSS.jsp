<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*"%>
<%
String clientId = request.getParameter("client_id");
if(clientId==null || clientId=="null")
	clientId = "";
String clientSecret = request.getParameter("client_secret");
if(clientSecret==null || clientSecret=="null")
	clientSecret = "";
String getAccessToken = request.getParameter("getAccessToken");
String print = "";
%>

<form name="getAccessToken" method="post">
API Key <input type="text" name="client_id" value="<%=clientId%>" size=40 /><br>
API Secret <input type="text" name="client_secret" value="<%=clientSecret%>" size=40 /><br>
<input type="submit" name="getAccessToken" value="Submit" />
</form><br><br>

   <%   
       if(getAccessToken!=null) {
           String url ="https://beta-api.att.com/oauth/access_token";   
           HttpClient client = new HttpClient();
           GetMethod method = new GetMethod(url);   
           method.setQueryString("grant_type=client_credentials&client_id=" + clientId + "&client_secret=" + clientSecret);
           int statusCode = client.executeMethod(method);    
           print = method.getResponseBodyAsString();
           if(statusCode==200){ String accessToken = print.substring(18,50);
           session.setAttribute("accessToken", accessToken);
           }
           method.releaseConnection();
       }
   %>   

<br><br><html><body><%=print%></body></html>