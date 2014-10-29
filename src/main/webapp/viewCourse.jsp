<!DOCTYPE html>
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
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilter" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<html>
<head>
    <title>courses</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>

<div class="navbar navbar-default">
 	<div class="navbar-collapse collapse navbar-responsive-collapse">
    	<ul class="nav navbar-nav">
      		<li><a href="/index.jsp">Home</a></li>
      		<li><a href="/courses.jsp">Courses</a></li>
      		<li><a href="/discuss">Discuss</a></li>
			<% 
				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();
				if(user == null){
			%>
      			<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
      		<%
				} else{
      		%>
      			<li><a href="<%=userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a></li>
      		<%
			    }
			%>
      		
        </ul>
    </div>
</div>
<br>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
<%
	String course = request.getParameter("courseName");
	
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	
	Filter courseFilter =new FilterPredicate("courseName",FilterOperator.EQUAL,course);
 	
	Query q = new Query("Courses").setFilter(courseFilter);
	
    List<Entity> courses = ds.prepare(q).asList(FetchOptions.Builder.withLimit(5));
    if(courses.isEmpty()){
%>
			<h1>No course...</h1>
<%
    }else{
    	for (Entity e : courses) {
            pageContext.setAttribute("value_content",
                    e.getProperty("courseName"));
%>
			<h1>${fn:escapeXml(value_content)}</h1>
<%
    	}
    }
%>

			<div class="col-md-6 col-lg-6">
				<h2>Chapters:</h2>
				<div class="btn-group btn-group-justified">
					  <a href="#" class="btn btn-success addChapterBtn">Add Chapter!</a>
					  <a href="#" class="btn btn-default courseSummary">Show Summary!</a>
					  <a href="#" class="btn btn-primary backCourse">Back</a>
				</div>
			</div>
			<div class="col-md-6 col-lg-6">
				<h2>Tasks:</h2>
			</div>
		</div>
	</div>
</div>



</body>
</html>