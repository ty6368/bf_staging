To utilize the functions in index.jsp, you must first get an Access Token using oauth.jsp. Once received, oauth.jsp will save this access token as a session variable accessible to index.jsp. If you access index.jsp without an access token saved in the session, it will provide a link to oauth.jsp, which will redirect you back to index.jsp after authentication.

Installation:
	1. Install Apache Tomcat 7.0 web server and configure java environment.
	2. Deploy WAR file through Tomcat manager, or place contents in Tomcat directory under webapps/{WAR NAME}, i.e. Tomcat/webapps/TL or Tomcat/webapps/DC, etc.
	3. Access the scriptlet by directing your browser to http://localhost:8080/{WAR NAME}, for example.

Configuration:
	1. Open oauth.jsp with an editor and enter your API Key and API Secret for variables clientId and clientSecret, respectively. These were provided when you registered your app.
	2. You may also wish to configure the oauth.jsp scriptlet for external access by changing the redirectUri variable in oauth.jsp to include your web server's external IP address instead of localhost.
	3. If you are using a payment method, open index.jsp with an editor and change the default values for the three redirect URIs, i.e. fulfillment redirect URI, cancel redirect URI, status callback redirect URI. These should be set to your external IP address instead of localhost.	