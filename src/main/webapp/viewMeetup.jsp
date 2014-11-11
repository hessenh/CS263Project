<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="java.util.logging.Level"%>
<html>
<head>
    <title>chapter</title>
    <link rel="stylesheet" href="/stylesheets/bootstrap.css">
</head>
<body>

<div class="navbar navbar-default">
 	<div class="navbar-collapse collapse navbar-responsive-collapse">
    	<ul class="nav navbar-nav">
      		<li><a href="/index.jsp">Home</a></li>
      		<li><a href="/courses.jsp">Courses</a></li>
      		<li><a href="/discuss">Discuss</a></li>
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
<%	
	
	String meetupName = request.getParameter("meetupName");
	pageContext.setAttribute("meetupName",meetupName);
	
	session = request.getSession(true);
	session.setAttribute("meetupName",meetupName);
	
	MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	
	String key = meetupName + "meetup";
	
	Entity meetupEntity = (Entity) syncCache.get(key);
	
	if(meetupEntity ==null){
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		
		Filter meetupFilter =new FilterPredicate("meetupName",FilterOperator.EQUAL,meetupName);
		
	    Query q = new Query("Meetups").setFilter(meetupFilter);
	    PreparedQuery pq = ds.prepare(q);
	    
	    meetupEntity= pq.asSingleEntity();
	    
	    syncCache.put(key, meetupEntity);
	    System.out.println("Putting meetup in memcache");
	}
	else{
		System.out.println("Getting meetup from memcache");
	}
	
  	
    pageContext.setAttribute("meetupName",meetupEntity.getProperty("meetupName"));
    pageContext.setAttribute("meetupInfo",meetupEntity.getProperty("meetupInfo"));
    pageContext.setAttribute("meetupDate",meetupEntity.getProperty("meetupDate"));
    pageContext.setAttribute("meetupTime",meetupEntity.getProperty("meetupTime"));
    pageContext.setAttribute("meetupAddress",meetupEntity.getProperty("meetupAddress"));
    
%>
<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
			<div class="col-md-6 col-lg-6">
				<div class="jumbotron">
					<h2>${fn:escapeXml(meetupName)}</h2>
	
					<h3>What - ${fn:escapeXml(meetupInfo)}</h3><br>
					<h3>When - ${fn:escapeXml(meetupDate)}, ${fn:escapeXml(meetupTime)}</h3><br>
					<h3>Where -  ${fn:escapeXml(meetupAddress)}</h3><br>
			
					<a class="btn btn-primary" href="/editMeetup.jsp">Edit</a>
					<a class="btn btn-primary" href="/meetupList.jsp">Back</a>

				</div>
			</div>
			<div class="col-md-6 col-lg-6">
				<div class="jumbotron">
					<h2>Participants</h2>
			
					<h3>Hans-Olav</h3>
				
					<a class="btn btn-succsess">Join</a>
				</div>	
			</div>
		</div>
	</div>
</div>

</body>
</html>