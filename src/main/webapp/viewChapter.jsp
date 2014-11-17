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
    <title>chapter</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<%	
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	
	String chapter = request.getParameter("chapterName");
	pageContext.setAttribute("chapterName",chapter);
	
	session = request.getSession(true);
	session.setAttribute("chapter",chapter);
	
	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = session.getAttribute("course")+chapter+user.getUserId();
	
	Entity chapterEntity = (Entity) syncCache.get(key);
	
	if(chapterEntity ==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		
		Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		Filter chapterFilter = new FilterPredicate("chapterName",FilterOperator.EQUAL,chapter);
		
	    Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter).setFilter(chapterFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    chapterEntity= pq.asSingleEntity();
	    
	    syncCache.put(key, chapterEntity);
	    System.out.println("Putting chapter in memcache");
	}
	else{
		System.out.println("Getting chapter from memcache");
	}
	
  	
    pageContext.setAttribute("chapterSummary",chapterEntity.getProperty("summary"));
    pageContext.setAttribute("courseName",session.getAttribute("course"));
    
%>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
			<div class="jumbotron jumbotron-subChapter">
				<div class="jumbotron-subChapter-header">
					<h2>Chapter: ${fn:escapeXml(chapterName)}</h2>
				</div>
				<div class="jumbotron-subChapter-content">
					<h3>${fn:escapeXml(chapterSummary)}</h3><br>
					
				</div>
				<div class="jumbotron-subChapter-footer">
					<a class="btn btn-primary" href="/editChapter.jsp">Edit</a>
					<a class="btn btn-primary" href="/viewCourse.jsp?courseName=${fn:escapeXml(courseName)}">Back</a>
			
				</div>
					
			</div>
		</div>
	</div>
</div>
</body>
</html>