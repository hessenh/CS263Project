<!DOCTYPE html>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
	<title>ViewMeetup</title>
	<link rel="stylesheet" href="/stylesheets/boot2.css">
	<meta charset="utf-8">
	
</head>
<body> 
	<jsp:include page="/navbar.jsp"></jsp:include>


<%
pageContext.setAttribute("meetupName",session.getAttribute("meetupName"));
%>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
		<%
		if(null != session.getAttribute("twitter")){
		%>
		<h1>Your meetup tweet!</h1><br>
		
		    <form action="./post" method="post">
		    	<h3 name="title">Check out this meetup! ${fn:escapeXml(meetupName)} is going to be awsome!  </h3><br>
				<h3 name="link">http://hansolahucsb.appspot.com/viewMeetup.jsp?meetupName=${fn:escapeXml(meetupName)}</h3>
		        <textarea cols="80" rows="2" name="text" placeholder="and add additional text if you want!" ></textarea>
		        <input type="submit" name="post" value="Tweet!"/>
	
		    </form>
		    <a href="./logout">logout</a>
		 <%
		}else{
		 %>
		 <h3>Sign in with your Twitter account to tweet!</h3>
		 <a class="btn btn-primary" href="signin">Sign in!</a>

		  <%} %>
		</div>
	</div>
</div>

</body>
</html>