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

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New question</h2>
			<form action="/addQuestion" method="post">
				<input type="text" name="questionTitle" class="form-control" placeholder="Question title" required><br>
				<input type="text" name="questionInfo" class="form-control" placeholder="Question Info" required>
				<button type="submit" class="btn btn-primary">Submit</button>
			</form>
		</div>
	</div>
</div>

</body>