<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%
	//Setting up the blobstore
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>
<html>
<head>
    <title>addTask</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>


<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New Task</h2>
			<form action="<%= blobstoreService.createUploadUrl("/addTask") %>" method="post" enctype="multipart/form-data">
			
				<input type="text" name="taskName" class="form-control" placeholder="Task Name" required>
				<br>
				<textarea class="form-control" rows="3" name="taskInfo" placeholder="Task" required></textarea>
				 <input type="file" name="myFile" required>
				<button type="submit" class="btn btn-primary">Submit</button>
			</form>
		</div>
	</div>
</div>


</body>
</html>