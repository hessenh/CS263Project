<!DOCTYPE html>
<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<html>
<head>
    <title>Sign out</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>
<% 
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
if(user != null){
%>
<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<div class="jumbotron jumbotron">
				<h1>Sign out</h1>
				<p>Are you sure you want to sign out?</p>
				<p><a href="<%=userService.createLogoutURL(request.getRequestURI()) %>" class="btn btn-primary btn-lg">Yes!</a></p>
			</div>	
		</div>
	</div>
</div>
<%
}else{
%>		
<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<div class="jumbotron jumbotron">
				<h1>Signed out!</h1>
				<p>Hope to see you again soon!</p>
			</div>	
		</div>
	</div>
</div>	
<%
}
%>

</body>
</html>