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
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%
	
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>
<html>
<head>
    <title>editTask</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<%
	//Fetching the task from the datastore and dispaly it on the html
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	//Filters for the query
	Filter taskFilter =new FilterPredicate("taskName",FilterOperator.EQUAL,session.getAttribute("task"));
	Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
	Filter courseFilter = new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
	
	Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter).setFilter(taskFilter);
	PreparedQuery pq = ds.prepare(q);
	
	Entity taskEntity = pq.asSingleEntity();
	//Setting the html content from the entity
	pageContext.setAttribute("taskInfo",taskEntity.getProperty("taskInfo"));
	pageContext.setAttribute("taskName",taskEntity.getProperty("taskName"));
%>

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>Edit task</h2>
			<form action="<%= blobstoreService.createUploadUrl("/editTask") %>" method="post" enctype="multipart/form-data">
				<input type="text" name="taskName" class="form-control" value="${fn:escapeXml(taskName)}">
				<br>
				<input type="text" name="taskInfo"  class="form-control" value="${fn:escapeXml(taskInfo)}">
				<br>
				<input type="file" name="myFile">
				<br>
				<div class="btn-group btn-group-justified">
					<a><button type="submit" name="save" class="btn btn-primary">Save</button></a>
					<a><button name= "delete" class="btn btn-danger">Delete</button></a>
					<a><button name="cancel" class="btn btn-default">Cancel</button></a>
				</div>
			</form>
		</div>
	</div>
</div>

</body>
</html>