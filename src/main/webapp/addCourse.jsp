<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html>
<head>
    <title>courses</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New Course</h2>
			<form action="/addCourse" method="post">
				<input type="text" name="courseName" class="form-control" placeholder="Course Name">
				<button type="submit" class="btn btn-primary submitCourse">Submit</button>
			</form>
		</div>
	</div>
</div>


</body>
</html>