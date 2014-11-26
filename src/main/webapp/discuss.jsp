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
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="java.util.logging.Level"%>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>


<body>
<jsp:include page="/navbar.jsp"></jsp:include>

<header class="homeHeader">
    <div class="container">
        <!-- <span class="brand-name">Start Tutor</span> -->
        <h1>Find your answer!</h1>
        <br>
        <a href="/newQuestion.jsp" class="btn btn-default">Ask a question</a>
    </div>
</header>
<div class="col-lg-12">
	<div class="container">
	    <div class="row home-intro text-center">
	        <div class="col-lg-12">
<!-- 	            <h2 class="tagline">Free, fast, and easy to use.</h2> -->
	            <p class="lead">Ask whatever you want!</p>
	            <hr class="small">
	        </div>
	    </div>
<%
List<Entity> questions;
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();

DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

Query query = new Query("Questions");
PreparedQuery pq = ds.prepare(query);
questions = pq.asList(FetchOptions.Builder.withLimit(9));
if(!questions.isEmpty()){
	for (Entity e : questions) {
		//int i = (e.getProperty("questionTitle").toString().length() < 10)?e.getProperty("questionTitle").toString().length():10;
        pageContext.setAttribute("questionTitle",
                e.getProperty("questionTitle"));
        
        int j = (e.getProperty("questionInfo").toString().length() < 10)?e.getProperty("questionInfo").toString().length():10;
        pageContext.setAttribute("questionInfo",
                e.getProperty("questionInfo").toString().substring(0, j)+"...");
%>
	    <div class="col-lg-4 col-sm-4">
	        <div class="thumbnail">
	            <div class="caption">
	            	<blockquote>
				  		<h3>${fn:escapeXml(questionTitle)}</h3>
					</blockquote>
					<blockquote>
				  		<p>${fn:escapeXml(questionInfo)}</p>
					</blockquote>
					
	                <a href="/viewQuestion.jsp?questionTitle=${fn:escapeXml(questionTitle)}" class="btn btn-default">View</a>
	            </div>
	        </div>
	    </div>
<%
	}
}
%>
	</div>
</div>
</body>