<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>

<div class="navbar navbar-default">
 	<div class="navbar-collapse collapse navbar-responsive-collapse">
    	<ul class="nav navbar-nav">
      		<li><a href="/index.jsp">Home</a></li>
			<% 
				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();
				if(user == null){
			%>
      			<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
      		<%
				} else{
      		%>
      			<li><a href="/courses.jsp">Courses</a></li>
      			<li><a href="/map.jsp">Discuss</a></li>
      			<li><a href="/meetups.jsp">Meetups</a></li>
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
			<div class="jumbotron meetup">
				<h2>Meetups!</h2>
				<p>Find out if there is a meetup or start a new meetup!</p>
				<p><a class="btn btn-primary btn-lg" href="/meetupList.jsp">Start!</a></p>
			</div>	
		</div>
	</div>
</div>

</body>
</html>