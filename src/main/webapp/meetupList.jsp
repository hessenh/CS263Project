<!DOCTYPE html>
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="java.util.logging.Level"%>
<html>
<head>
    <title>Meetup</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>

<div class="container">
	<div class="row">
		<div class="col-md-12 col-lg-12">
			<h1>Meetups!</h1>
			<%
				//Get the different meetups from datastore or memcache
				List<Entity> meetups;
			
				MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
			 	syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
			 	
			 	//Try to get from memcache
			 	meetups =  (List<Entity>) syncCache.get("meetups");
			 
			 	//If it fails, go to the datastore
			 	if(meetups==null){
			 		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
				 	
				 	
				    Query query = new Query("Meetups");
				    PreparedQuery pq = ds.prepare(query);
				    meetups = pq.asList(FetchOptions.Builder.withLimit(10));
				    System.out.println(meetups.size());
				    System.out.println("Putting meetups in memcache. Key is 'meetups'");
				    //Put in memcache
				    syncCache.put("meetups",meetups);
			 	}
			 	else{
			 		System.out.println("Getting meetups from memcache");
			 	}
				
			    if(meetups.isEmpty()){
			%>
				<h3>No meetups yet.. Create one! </h3>
			<%
				//Display all the different meetups
			    }else{
			    	for (Entity e : meetups) {
			            pageContext.setAttribute("meetupName",e.getProperty("meetupName"));
			%>
				<a class="btn btn-default btn-lg btn-block" href="/viewMeetup.jsp?meetupName=${fn:escapeXml(meetupName)}">${fn:escapeXml(meetupName)}</a>
			<%
			    	}
			    }
			%>	
			<a class="btn btn-success btn-lg btn-block addCourseBtn" href="addMeetup.jsp">Create new meetup!</a>
		</div>
	</div>
</div>

</body>
</html>