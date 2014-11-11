<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html>
<head>
    <title>Add meetup</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>

<div class="navbar navbar-default">
 	<div class="navbar-collapse collapse navbar-responsive-collapse">
    	<ul class="nav navbar-nav">
      		<li><a href="/index.jsp">Home</a></li>
      		<li><a href="/courses.jsp">Courses</a></li>
      		<li><a href="/discuss">Discuss</a></li>
      		<li><a href="/meetups.jsp">Meetups</a></li>
			<% 
				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();
				if(user == null){
			%>
      			<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
      		<%
				} else{
      		%>
      			<li><a href="<%=userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a></li>
      		<%
			    }
			%>
      		
        </ul>
    </div>
</div>
<br>
<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New meetup</h2>
			<form action="/addMeetup" method="post">
				<input type="text" name="meetupName" class="form-control" placeholder="Title"><br>
				<input type="text" name="meetupInfo" class="form-control" placeholder="Info"><br>
				<input type="date" name="meetupDate">
				<input type="time" name="meetupTime"><br>
				<button type="submit" class="btn btn-primary">Next</button>
			</form>
		</div>
	</div>
</div>


</body>
</html>