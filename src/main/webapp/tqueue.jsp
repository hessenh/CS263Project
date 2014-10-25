<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>
<%	
	String value = request.getParameter("value");
	String res = "Empty";
	
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
 	Key guestbookKey = KeyFactory.createKey("TaskData", value);
    Query q = new Query(guestbookKey);
    List<Entity> result = ds.prepare(q).asList(FetchOptions.Builder.withLimit(5));
    if(result.isEmpty()){
%>
<h1>No result.. Try it again!</h1>
<%
} else {
%>
<h1>Result:</h1>
<%
    for (Entity e : result) {
        pageContext.setAttribute("value_content",
                e.getProperty("value"));
    
%>
<h2>The keyname is <%=value%> and the value is ${fn:escapeXml(value_content)}</h2>
	
<%
        }
    }
%>
</body>
</html>