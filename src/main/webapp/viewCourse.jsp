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
    <title>courses</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if( user ==null){
		response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
	}
	else{
	
	String course = request.getParameter("courseName");
	
	session  = request.getSession(true);
	session.setAttribute("course", course);
	
	pageContext.setAttribute("course_name",course);
%>
			<h1>${fn:escapeXml(course_name)}</h1>
			<div class="col-md-6 col-lg-6">
				
				<h2>Chapters:</h2>
<%
	//Fetch the different chapters for the specific course from the datastore and memcache
	List<Entity> chapters;

	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = course+user.getUserId();
	chapters =  (List<Entity>) syncCache.get(key);
	
	if(chapters==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,course);
		Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		
	    Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    chapters = pq.asList(FetchOptions.Builder.withLimit(5));
		syncCache.put(key,chapters);
		System.out.println("Putting chapters in memcache with key: " + key);
	}
	else{
		System.out.println("Getting chapters from memcache");
	}
	
    if(chapters.isEmpty()){
%>

<%
    }else{
    	//Display each chapter
    	for (Entity e : chapters) {
            pageContext.setAttribute("chapter_content",
                    e.getProperty("chapterName"));
%>
				<a class="btn btn-default btn-lg btn-block" href="/viewChapter.jsp?chapterName=${fn:escapeXml(chapter_content)}">${fn:escapeXml(chapter_content)}</a>
<%
    	}
    }
%>		
				<br>
				<div class="btn-group btn-group-justified">
					  <a href="/addChapter.jsp" class="btn btn-success">Add Chapter!</a>
					  <a href="/courseSummary.jsp" class="btn btn-default">Show Summary!</a>
					  <a href="/courses.jsp" class="btn btn-primary">Back</a>
				</div>
			</div>
			<div class="col-md-6 col-lg-6">
				<h2>Tasks:</h2>
<%
	List<Entity> tasks;

	syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	key = course+user.getUserId()+"task";
	
	tasks =  (List<Entity>) syncCache.get(key);
	
	if(tasks==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,course);
		Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		
	    Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    tasks = pq.asList(FetchOptions.Builder.withLimit(5));
		syncCache.put(key,tasks);
		System.out.println("Putting tasks in memcache with key: " + key);
	}
	else{
		System.out.println("Getting tasks from memcache");
	}
	
    if(tasks.isEmpty()){
%>
	
<%
    }else{
    	for (Entity e : tasks) {
            pageContext.setAttribute("task_content",
                    e.getProperty("taskName"));
%>
				<a class="btn btn-default btn-lg btn-block" href="/viewTask.jsp?taskName=${fn:escapeXml(task_content)}">${fn:escapeXml(task_content)}</a>
<%
    	}
    }
%>					
				<a class="btn btn-success btn-lg btn-block" href="/addTask.jsp">Add Task!</a>
			</div>
		</div>
	</div>
</div>
<%
}%>



</body>
</html>