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
	//Fetching question from datastore or memcache
	String questionTitle = request.getParameter("questionTitle");
	session.setAttribute("questionTitle", questionTitle);
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
	session.setAttribute("questionInfo", questionEntity.getProperty("questionInfo"));
	//Setting the different html fields
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
		//Fetching the answer to the current question from memcahce or datastore
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		List<Entity> questionAnswers = (List<Entity>) syncCache.get(questionTitle+"answer");
		if(questionAnswers == null){
			DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			Filter questionTitleFilter = new FilterPredicate("questionTitle",FilterOperator.EQUAL,questionTitle);
			Filter questionInfoFilter = new FilterPredicate("questionInfo",FilterOperator.EQUAL,session.getAttribute("questionInfo"));
			Query q = new Query("QuestionAnswer").setFilter(questionTitleFilter).setFilter(questionInfoFilter);
			PreparedQuery pq = ds.prepare(q);
			
			questionAnswers = pq.asList(FetchOptions.Builder.withLimit(10));
			System.out.println("Putting qAnswers in memcache");
			syncCache.put(questionTitle+"answer",questionAnswers);
		}
		else{
			System.out.println("Getting qAnswers from memcache");
		}
		
		if(questionAnswers.isEmpty()){
			%>
				<h3></h3>
			<%
	    }else{
	    	//Display answers
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
		<h3>Leave a comment!</h3>
		<form action="/addAnswer" method="post">
			<input type="text" name="answer" class="form-control" placeholder="Comment.." required>
		   	<button name="answer" type="submit" class="btn btn-primary">Submit</button>
		</form>
	</div>	
</div>

</body>
</html>