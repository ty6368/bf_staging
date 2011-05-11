<%@ page language="java" errorPage="" %>
<%@ page import="com.sun.jersey.multipart.file.*" %>
<%@ page import="com.sun.jersey.multipart.BodyPart" %>
<%@ page import="com.sun.jersey.multipart.MultiPart" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sentaca.rest.client.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.ws.rs.core.*" %>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.List,java.util.Iterator"%>

<%
String accessToken = request.getParameter("access_token");
if(accessToken==null || accessToken=="null"){
	accessToken = (String) session.getAttribute("accessToken");}
if(accessToken==null || accessToken=="null") {
	accessToken = "";
	session.setAttribute("postOauth", "index.jsp");
	%><a href="oauth.jsp">Authenticate first</a><br><br><%
}
String sendMms = request.getParameter("sendMms");
String endpoint = "https://beta-api.att.com/1/messages/outbox/mms";		
String contentBodyFormat = "FORM-ENCODED";		
String address = "";		
String fileName = "";		
String subject = "";		
String priority = "";
String responseFormat = "";
String print = "";
%>

<form name="sendMms" enctype="multipart/form-data" method="post">
	Access Token <input type="text" name="accessToken" value="<%=accessToken%>" size=40/><br>
	MSISDN <input type="text" name="address" value="tel:" /><br />
	Subject <input type="text" name="subject" value="Test." size=40/><br />
	Priority <input type="text" name="priority" value="High" size=40/><br />
	Response Format: <input type="radio" name="responseFormat" value="xml">XML<input type="radio" name="responseFormat" value="json" checked>JSON<br/>
	Attachment <input type="file" name="f1" /><br>
	<input type="submit" name="sendMms" value="Send MMS"/>
</form>

<% if(request.getContentType()!=null) {	

        DiskFileUpload fu = new DiskFileUpload();
        List fileItems = fu.parseRequest(request);
        Iterator itr = fileItems.iterator();
        while(itr.hasNext()) {
          FileItem fi = (FileItem)itr.next();
          if(!fi.isFormField()) {
            	File fNew= new File(application.getRealPath("/"), fi.getName());
            	fileName = "/" + fi.getName();
            	fi.write(fNew);
          } else if(fi.getFieldName().equalsIgnoreCase("address")) {
            	address = fi.getString();
          } else if(fi.getFieldName().equalsIgnoreCase("subject")) {
          	subject = fi.getString();
          } else if(fi.getFieldName().equalsIgnoreCase("priority")) {
          	priority = fi.getString();
          } else if(fi.getFieldName().equalsIgnoreCase("responseFormat")) {
          	responseFormat = fi.getString();
          } else if(fi.getFieldName().equalsIgnoreCase("accessToken")) {
          	accessToken = fi.getString();
          	session.setAttribute("accessToken", accessToken);
          }
        }		
		String attachmentsStr = fileName;
		String[] attachments = attachmentsStr.split(",");

		FileDataBodyPart fIlE = new FileDataBodyPart();
		MediaType medTyp = fIlE.getPredictor().getMediaTypeFromFileName(fileName);
		
		MediaType contentBodyType = null;
		String requestBody = "";
		if (contentBodyFormat != null && contentBodyFormat.equalsIgnoreCase("form-encoded"))
		{
			contentBodyType = MediaType.MULTIPART_FORM_DATA_TYPE;
			requestBody += "address=" + URLEncoder.encode(address, "UTF-8") + "&";	
			requestBody += "priority=" + URLEncoder.encode(priority, "UTF-8") + "&";
			requestBody += "subject=" + URLEncoder.encode(subject, "UTF-8") + "&";
			requestBody += "content-type=" + URLEncoder.encode(medTyp.toString(), "UTF-8") + "\r\n";
		}
		
		ServletContext context = getServletContext();
   		InputStream is = context.getResourceAsStream(attachments[0]);				
		
		MultiPart mPart = new MultiPart().bodyPart(new BodyPart(requestBody,MediaType.APPLICATION_FORM_URLENCODED_TYPE)).bodyPart(new BodyPart(is, medTyp));
		mPart.getBodyParts().get(1).getHeaders().add("Content-Transfer-Encoding", "binary");
		mPart.getBodyParts().get(1).getHeaders().add("Content-Disposition","attachment; name=\"\"; filename=\"\"");
		mPart.getBodyParts().get(0).getHeaders().add("Content-Transfer-Encoding", "8bit");
		mPart.getBodyParts().get(0).getHeaders().add("Content-Disposition","form-data; name=\"root-fields\"");
		mPart.getBodyParts().get(0).getHeaders().add("Content-ID", "<startpart>");
		mPart.getBodyParts().get(1).getHeaders().add("Content-ID", "<attachment>");
		// This currently uses a proprietary rest client to assemble the request body that does not follow SMIL standards. It is recommended to follow SMIL standards to ensure attachment delivery.
		RestClient client = new RestClient(endpoint, contentBodyType, MediaType.APPLICATION_JSON_TYPE);
		client.addParameter("access_token", accessToken);
		client.addRequestBody(mPart);
		String responze = client.invoke(HttpMethod.POST, true);
		
		if (client.getHttpResponseCode() == 201) {
			print = responze;
		} else {
			print = responze;
		}
	}	
%>

<br><br><html><body><%=print%></body></html>