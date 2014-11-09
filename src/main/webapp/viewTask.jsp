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
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="java.util.logging.Level"%>
<html>
<head>
    <title>viewTask</title>
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
<%	
	
	String task = request.getParameter("taskName");
	pageContext.setAttribute("taskName",task);
	
	session = request.getSession(true);
	session.setAttribute("task",task);
	
	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = session.getAttribute("course")+user.getUserId()+task;
	
	Entity taskEntity = (Entity) syncCache.get(key);
	
	if(taskEntity ==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		
		Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		Filter taskFilter = new FilterPredicate("taskName",FilterOperator.EQUAL,task);
		
		
	    Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter).setFilter(taskFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    taskEntity= pq.asSingleEntity();
	    
	    syncCache.put(key, taskEntity);
	    System.out.println("Putting task in memcache");
	}
	else{
		System.out.println("Getting task from memcache");
	}
	
  	
    pageContext.setAttribute("taskInfo",taskEntity.getProperty("taskInfo"));
    pageContext.setAttribute("courseName",session.getAttribute("course"));
    
%>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
			<div class="jumbotron jumbotron-subChapter">
				<div class="jumbotron-subChapter-header">
					<h2>Task: ${fn:escapeXml(taskName)}</h2>
				</div>
				<div class="jumbotron-subChapter-content">
					<h3>${fn:escapeXml(taskInfo)}</h3><br>
					
				</div>
				<div class="jumbotron-subChapter-footer">
					<a class="btn btn-primary" href="/editTask.jsp">Edit</a>
					<a class="btn btn-primary" href="/viewCourse.jsp?courseName=${fn:escapeXml(courseName)}">Back</a>
			
				</div>
					
			</div>
		</div>
	</div>
</div>
</body>
</html>