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
    <title>summary</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<%
	//Getting the different summaries from datastore
	
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	
	session = request.getSession(true);
	Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
	Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
	//Setting up query
    Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter);
    PreparedQuery pq = ds.prepare(q);
    
    List<Entity> summaryList= pq.asList(FetchOptions.Builder.withLimit(10));
    
    pageContext.setAttribute("courseName",session.getAttribute("course"));
%>
	<div class="container">
		<div class="row">
			<div class="col-md-12 col-lg-12">
				<h2>Summary of ${fn:escapeXml(courseName)}</h2>

<%
    if(summaryList.isEmpty()){
%>
    		<h3>No chapters yet!</h3>
<%
	//Dispaly the summaries
    }else{
 	    	for (Entity e : summaryList) {
 	            pageContext.setAttribute("chapterName",e.getProperty("chapterName"));
 	            pageContext.setAttribute("chapterSummary",e.getProperty("summary"));
%>
			<div class="jumbotron jumbotron-subChapter">
				<div class="jumbotron-subChapter-header">
					<h2>Chapter ${fn:escapeXml(chapterName)}</h2>
				</div>
				<div class="jumbotron-subChapter-content">
					<h3>${fn:escapeXml(chapterSummary)}</h3><br>
					
				</div>
			</div>

<%
    	}
    }
%>				
		</div>
	</div>
</div>
</body>
</html>