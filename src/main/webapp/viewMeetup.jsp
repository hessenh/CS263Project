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
	<link rel="stylesheet" href="/stylesheets/bootstrap.css">
	<meta charset="utf-8">
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> 
	<script type="text/javascript">
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
	    	
	    	
	    	
        	
              //map.setCenter(location);
        }
	    
	</script>
</head>
<body> 
	<jsp:include page="/navbar.jsp"></jsp:include>
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
    pageContext.setAttribute("meetupLat",meetupEntity.getProperty("meetupLat"));
    pageContext.setAttribute("meetupLng",meetupEntity.getProperty("meetupLng"));
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
					<a onclick="placeMarker(${fn:escapeXml(meetupLat)},${fn:escapeXml(meetupLng)})" class="btn btn-primary">Show on map!</a>

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
		<div class="col-md-12 col-lg-12">
			<div class="col-md-1 col-lg-1">
			</div>
			<div id ="mapDiv" hidden="true" class="col-md-8 col-lg-10">
				
				<div id="map_canvas" style="width:100%; height:400px"></div>
			</div>
			<div class="col-md-1 col-lg-1">
			</div> 
		</div>
	</div>
</div>

</body>
</html>