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
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<%	
	//Fetch the task from memcache or datastore
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	String task = request.getParameter("taskName");
	pageContext.setAttribute("taskName",task);
	
	session = request.getSession(true);
	session.setAttribute("task",task);
	
	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = session.getAttribute("course")+task+user.getUserId();
	
	Entity taskEntity = (Entity) syncCache.get(key);
	
	//If memcahce fails
	if(taskEntity ==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		
		Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		Filter taskFilter = new FilterPredicate("taskName",FilterOperator.EQUAL,task);
		
		
	    Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter).setFilter(taskFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    taskEntity= pq.asSingleEntity();
	    
	    //Putting task in memcache
	    syncCache.put(key, taskEntity);
	    System.out.println("Putting task in memcache with key: " + key);
	}
	else{
		System.out.println("Getting task from memcache");
	}
	
  	//Setting the different html fields
    pageContext.setAttribute("taskInfo",taskEntity.getProperty("taskInfo"));
    pageContext.setAttribute("courseName",session.getAttribute("course"));
    pageContext.setAttribute("fileKey",taskEntity.getProperty("file"));
    
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
					<a class="btn btn-primary" href="/serve?blob-key=${fn:escapeXml(fileKey)}">File</a>
					<a class="btn btn-primary" href="/viewCourse.jsp?courseName=${fn:escapeXml(courseName)}">Back</a>
			
				</div>
					
			</div>
		</div>
	</div>
</div>
</body>
</html>