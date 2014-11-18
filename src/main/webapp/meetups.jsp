<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
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
			<div class="jumbotron meetup">
				<h2>Meetups!</h2>
				<p>Find out if there is a meetup or start a new meetup!</p>
				<p><a class="btn btn-primary btn-lg" href="/meetupList.jsp">Continue!</a></p>
			</div>	
		</div>
	</div>
</div>

</body>
</html>