<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*"%>
<%@ page import="org.json.JSONObject"%>
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
String requestedAccuracy = request.getParameter("requestedAccuracy");
String getDeviceLocation = request.getParameter("getDeviceLocation");
String print = "";
%>

<form name="getDeviceLocation" action="" method="post">
Address <input type="text" name="address" value="tel:" /><br>
Requested Accuracy <input type="text" name="requestedAccuracy" value="100" /><br>
Access Token <input type="text" name="access_token" value="<%=accessToken%>" size=40/><br>
<input type="submit" name="getDeviceLocation" value="Get Device Location" />
</form>

<%  
if(getDeviceLocation!=null) {
    String url ="https://beta-api.att.com/1/devices/" + address + "/location";   
    HttpClient client = new HttpClient();
    GetMethod method = new GetMethod(url);  
    method.setQueryString("access_token=" + accessToken + "&requestedAccuracy=" + requestedAccuracy);
    method.addRequestHeader("Accept","application/json");
    int statusCode = client.executeMethod(method);    
    if(statusCode==200) {
    	JSONObject rpcObject = new JSONObject(method.getResponseBodyAsString());
    	%><iframe width="600" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" 
    		src="http://maps.google.com/?q=<%=rpcObject.getString("latitude")%>+<%=rpcObject.getString("longitude")%>&output=embed"></iframe><br /><%
    } else {
    	print = method.getResponseBodyAsString();
    }
    method.releaseConnection();
}
%> 

<br><br><html><body><%=print%></body></html>