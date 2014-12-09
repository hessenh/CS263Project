<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html>
<head>
    <title>courses</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>


<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New Chapter</h2>
			<form action="/addChapter" method="post">
				<input type="text" name="chapterName" class="form-control" placeholder="Chapter Name" required>
				<br>
				<textarea class="form-control" rows="3" name="summary" placeholder="Summary" required></textarea>
				<button type="submit" class="btn btn-primary submitChapter">Submit</button>
			</form>
		</div>
	</div>
</div>


</body>
</html>