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
	<title>ViewMeetup</title>
	<link rel="stylesheet" href="/stylesheets/boot2.css">
	<meta charset="utf-8">
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> 
	<script type="text/javascript">
		//Setting up the map
	    var map;
	    var marker;
	    var geocoder; //2a
	   
	    function placeMarker(lat,lng) {
	    	var location = new google.maps.LatLng(lat,lng);
	    	document.getElementById("mapDiv").removeAttribute("hidden");
	    	
	    	geocoder = new google.maps.Geocoder(); //2b
	        var duckOptions = { //3
	            zoom: 16,
	            center: location,
	            mapTypeId: google.maps.MapTypeId.STANDARD
	        };
	    	
	       
	        
	        map = new google.maps.Map(document.getElementById("map_canvas"), duckOptions); //4
	        marker = new google.maps.Marker({ //5
	            position: location, 
	            map: map
	        });
        }
	</script>
</head>
<body> 
	<jsp:include page="/navbar.jsp"></jsp:include>
<%	
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if( user ==null){
		System.out.println(request.getRequestURI());
		response.sendRedirect(userService.createLoginURL(request.getRequestURI()+"?meetupName=" + request.getParameter("meetupName")));
	}
	else{
	//Fecthing the meetup from datastore or memcahce
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
	//Setting the different html fields 
    pageContext.setAttribute("meetupName",meetupEntity.getProperty("meetupName"));
    pageContext.setAttribute("meetupInfo",meetupEntity.getProperty("meetupInfo"));
    pageContext.setAttribute("meetupDate",meetupEntity.getProperty("meetupDate"));
    pageContext.setAttribute("meetupTime",meetupEntity.getProperty("meetupTime"));
    pageContext.setAttribute("meetupAddress",meetupEntity.getProperty("meetupAddress"));
    pageContext.setAttribute("meetupLat",meetupEntity.getProperty("meetupLat"));
    pageContext.setAttribute("meetupLng",meetupEntity.getProperty("meetupLng"));
%>
<header class="createMeetupheader">
	<div class="container">
		<h2>${fn:escapeXml(meetupName)}</h2>
		<p>What: ${fn:escapeXml(meetupInfo)}</p>
		<p>When: ${fn:escapeXml(meetupDate)} at ${fn:escapeXml(meetupTime)}</p>
		<p>Where: ${fn:escapeXml(meetupAddress)}</p>
		<a class="btn btn-primary" href="/meetupList.jsp">Back</a>
		<a onclick="placeMarker(${fn:escapeXml(meetupLat)},${fn:escapeXml(meetupLng)})" class="btn btn-primary">Show on map! </a>
		<a class="btn btn-primary" href="/SignInTwitter.jsp">Tweet!</a>
	</div>
</header>
<div class="col-lg-10 col-lg-offset-2">
	<div class="col-lg-4">
		<h3>Participants:</h3>
<%
		//Fetching the participants and finding out if the current user is attending
		Boolean isAttending = false;
		syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		
		List<Entity> meetupAttending = (List<Entity>) syncCache.get(meetupName+"parList");
		if(meetupAttending==null){
			DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			Filter meetupFilter = new FilterPredicate("meetupName",FilterOperator.EQUAL,meetupName);
			
			Query q = new Query("MeeupAttending").setFilter(meetupFilter);
			PreparedQuery pq = ds.prepare(q);
			
			meetupAttending = pq.asList(FetchOptions.Builder.withLimit(10));
			syncCache.put(meetupName+"parList",meetupAttending);
			System.out.println("Putting parList in memcache");
		}
		else{
			System.out.println("Getting parList from memcache");
		}
		
		if(meetupAttending.isEmpty()){
			%>
				<h3>No participants!</h3>
			<%
	    }else{
	    	//Dispaly the people attending
    		for (Entity e : meetupAttending) {
	    		if(e.getProperty("userId").equals(user.getUserId())){
	    			isAttending = true;
	    		}
	            pageContext.setAttribute("meetup_person",
	                    e.getProperty("username"));
			%>
				<blockquote>
					<h3> ${fn:escapeXml(meetup_person)}</h3>
				</blockquote>
			<%
			}
  			}
		//If curent user is attending or not, show button depending on result
		if(!isAttending){
	   		%>
		<form action="/meetupAttend" method="post">
	   		<button name="attend" type="submit" class="btn btn-primary">Join</button>
		</form>
		<%
		}else{
			%>
		<form action="/meetupAttend" method="post">
		   	<button name="leave" type="submit" class="btn btn-primary">Leave</button>
		</form>
			<%
		}
			%>
	</div>	
		
	<div class="col-lg-8">
		<div id ="mapDiv" hidden="true" class="col-md-12 col-lg-12">
			<div id="map_canvas" style="width:100%; height:400px"></div>
		</div>
	</div>
</div>
<%} %>

</body>
</html>