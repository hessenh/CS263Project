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
	<title>ViewMeetup</title>
	<link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body> 
	<jsp:include page="/navbar.jsp"></jsp:include>
<%	
	
	String questionTitle = request.getParameter("questionTitle");
	pageContext.setAttribute("questionTitle",questionTitle);
	
	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = questionTitle;
	
	Entity questionEntity = (Entity) syncCache.get(key);
	
	if(questionEntity ==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		
		Filter questionFilter =new FilterPredicate("questionTitle",FilterOperator.EQUAL,questionTitle);
		
	    Query q = new Query("Questions").setFilter(questionFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    questionEntity= pq.asSingleEntity();
	    
	    syncCache.put(key, questionEntity);
	    System.out.println("Putting question in memcache");
	}
	else{
		System.out.println("Getting question from memcache");
	}
    pageContext.setAttribute("questionTitle",questionEntity.getProperty("questionTitle"));
    pageContext.setAttribute("questionInfo",questionEntity.getProperty("questionInfo"));
%>
<header class="createMeetupheader">
	<div class="container">
		<h2>${fn:escapeXml(questionTitle)}</h2>
		<p>${fn:escapeXml(questionInfo)}</p>
		<a class="btn btn-primary" href="/discuss.jsp">Back</a>
	</div>
</header>
<div class="col-lg-10 col-lg-offset-2">
	<div class="col-lg-4">
<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Filter questionTitleFilter = new FilterPredicate("questionTitle",FilterOperator.EQUAL,questionTitle);
		
		Query q = new Query("QuestionAnswer").setFilter(questionTitleFilter);
		PreparedQuery pq = ds.prepare(q);
		
		List<Entity> questionAnswers = pq.asList(FetchOptions.Builder.withLimit(10));
		if(questionAnswers.isEmpty()){
			%>
				<h3>No answers!</h3>
			<%
	    }else{
    		for (Entity e : questionAnswers) {
	            pageContext.setAttribute("answer",
	                    e.getProperty("answer"));
			%>
				<blockquote>
					<h3> ${fn:escapeXml(answer)}</h3>
				</blockquote>
			<%
			}
  			}
		%>
		<form action="/meetupAttend" method="post">
		   	<button name="leave" type="submit" class="btn btn-primary">Leave</button>
		</form>
	</div>	
</div>

</body>
</html>