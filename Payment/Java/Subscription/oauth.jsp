<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*"%>
<%
String clientId = "";
String clientSecret = "";
String redirectUri = "http://localhost:8080/Subscription/oauth.jsp";
String code = request.getParameter("code");
if(code==null) code="";
String print = "";
%>

<form name="getExtCode" action="https://beta-api.att.com/oauth/authorize" method="get">
<input type="hidden" name="client_id" value="<%=clientId%>" size=40 />
Scope <input type="text" name="scope" value="SMS,MMS,WAP,DC,TL,PAYMENT" size=40 /><br />
Redirect URI <input type="text" name="redirect_uri" value="<%=redirectUri%>" size=60 /><br />
<input type="submit" name="getExtCode" value="Submit" />
</form><br><br>

   <%   
       if(code.equalsIgnoreCase("")){} else {
           String url ="https://beta-api.att.com/oauth/access_token";   
           HttpClient client = new HttpClient();
           GetMethod method = new GetMethod(url);   
           method.setQueryString("grant_type=authorization_code&client_id=" + clientId + "&client_secret=" + clientSecret + "&code=" + code);
           int statusCode = client.executeMethod(method);    
           print = method.getResponseBodyAsString();
           if(statusCode==200){ 
           	String accessToken = print.substring(18,50);
           	session.setAttribute("accessToken", accessToken);
           	String postOauth = (String) session.getAttribute("postOauth");
           	if(postOauth!= null) {
           		session.setAttribute("postOauth", null);
           		response.sendRedirect(postOauth);
           	}
           }
           method.releaseConnection();
       }
   %>   

<br><br><html><body><%=print%></body></html>