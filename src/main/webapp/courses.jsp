<!DOCTYPE html>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>

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
					System.out.println("Out");
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
			<h1>Courses</h1>
			<%
				
				DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			 	//Key userKey = KeyFactory.createKey("Courses", user.getUserId());
			 	Key key = KeyFactory.createKey("Courses",user.getUserId());
			 	Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
			 	
			    Query query = new Query("Courses").setFilter(userFilter);
			    PreparedQuery pq = ds.prepare(query);
			    List<Entity> courses = pq.asList(FetchOptions.Builder.withLimit(5));
			    if(courses.isEmpty()){
			%>
				<h3>No courses yet!</h3>
			<%
			    }else{
			    	for (Entity e : courses) {
			            pageContext.setAttribute("course_content",
			                    e.getProperty("courseName"));
			%>
				<a class="btn btn-default btn-lg btn-block" href="/viewCourse.jsp?courseName=${fn:escapeXml(course_content)}">${fn:escapeXml(course_content)}</a>
			<%
			    	}
			    }
			%>	
				
			<a class="btn btn-success btn-lg btn-block addCourseBtn" href="addCourse.jsp">Add Course!</a>
		</div>
	</div>
</div>


</body>
</html>