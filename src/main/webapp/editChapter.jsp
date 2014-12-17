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
    <title>editChapter</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>

<jsp:include page="/navbar.jsp"></jsp:include>
<%
	//Fetching the chapter from the datastore and setting the different values in the html
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	//Filters for the query
	Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
	Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
	Filter chapterFilter = new FilterPredicate("chapterName",FilterOperator.EQUAL,session.getAttribute("chapter"));
	
	Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter).setFilter(chapterFilter);
	PreparedQuery pq = ds.prepare(q);
	
	Entity chapterEntity= pq.asSingleEntity();
	
	//Set the content of the html
	pageContext.setAttribute("chapterSummary",chapterEntity.getProperty("summary"));
	pageContext.setAttribute("chapterName",chapterEntity.getProperty("chapterName"));
%>

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>Edit Sub Chapter</h2>
			<form action="/editChapter" method="post">
				<input type="text" name="cName" class="form-control" value="${fn:escapeXml(chapterName)}" required>
				<br>
				<input type="text" name="cSummary"  class="form-control" value="${fn:escapeXml(chapterSummary)}"required>
				<br>
				<div class="btn-group btn-group-justified">
					<a><button type="submit" name="save" class="btn btn-primary">Save</button></a>
					<a><button href="#" name= "delete" class="btn btn-danger">Delete</button></a>
					<a><button href="#" name="cancel" class="btn btn-default">Cancel</button></a>
				</div>
			</form>
		</div>
	</div>
</div>

</body>
</html>