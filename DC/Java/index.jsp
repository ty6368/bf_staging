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
String getDeviceInfo = request.getParameter("getDeviceInfo");
String print = "";
%>

<form name="getDeviceInfo" action="" method="get">
Address <input type="text" name="address" value="tel:" /><br />
Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
<input type="submit" name="getDeviceInfo" value="Get Device Info" />
</form>

<%  
    if(getDeviceInfo!=null) {
        String url ="https://beta-api.att.com/1/devices/" + address + "/info";   
        HttpClient client = new HttpClient();
        GetMethod method = new GetMethod(url);  
        method.setQueryString("access_token=" + accessToken);
        method.addRequestHeader("Accept","application/json");
        int statusCode = client.executeMethod(method);    
        print = method.getResponseBodyAsString();
        System.out.println(method.getResponseBodyAsString());
        method.releaseConnection();
    }
%>  

<br><br><html><body><%=print%></body></html>