<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>

<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
	<div class="container">
   		<div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/index.jsp">Home</a>
        </div>
        <% 
			UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();
			if(user == null){
		%>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        	<ul class="nav navbar-nav">
        	
			</ul>
			<ul class="nav navbar-nav navbar-right">
           		<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
			</ul>
		</div>
		<%
			}else{
		%>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        	<ul class="nav navbar-nav">
	            <li><a href="/courses.jsp">Courses</a></li>
      			<li><a href="/discuss.jsp">Discuss</a></li>
      			<li><a href="/meetups.jsp">Meetups</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
           		<li><a href="/signOut.jsp">Sign out</a></li>
			</ul>
		</div>
		<%
			}
		%>
	</div>
</nav>
	
			
   