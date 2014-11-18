<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<html>
    <head>
        <title>Location</title>
        <link rel="stylesheet" href="/stylesheets/boot2.css">
        <meta charset="utf-8">
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> 
        <script type="text/javascript">
            var map;
            var marker;
            var geocoder; //2a
            var initialLocation = new google.maps.LatLng(34.41396,-119.84895); //2
            function init() {
            	geocoder = new google.maps.Geocoder(); //2b
                var duckOptions = { //3
                    zoom: 16,
                    center: initialLocation,
                    mapTypeId: google.maps.MapTypeId.STANDARD
                };
                map = new google.maps.Map(document.getElementById("map_canvas"), duckOptions); //4
                marker = new google.maps.Marker({ //5
                    position: initialLocation, 
                    map: map
                });
                google.maps.event.addListener(map, 'click', function(event) {
                    placeMarker(event.latLng);
                });
            }
            function placeMarker(location) {
            	marker.setMap(null);
                marker = new google.maps.Marker({
                    position: location,
                    map: map
                });
                //3 - all code until 
                document.getElementById('lat').value=location.lat();
            	document.getElementById('lng').value=location.lng();
            	
                //$("#longitude").val(location.lng());  
               //$("#latitude").val(location.lat());
                
                geocoder.geocode( { 'latLng': location}, function(results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                    	console.log(results[0].formatted_address);
                    	document.getElementById('address').value=results[0].formatted_address;
                        //$("#gaddress").val(results[0].formatted_address);
                    } else {
                        alert("Geocode was not successful for the following reason: " + status);
                    }
                });
                //the end of (3)
                map.setCenter(location);
            }
        </script>
    </head>
    <body  onload="init()"> 
	    <jsp:include page="/navbar.jsp"></jsp:include>
		<div class="container">
			<div class="row">
				<div class="col-md-10 col-lg-10">
			        <h1>Choose location</h1>
			        <div id="map_canvas" style="width:100%;height:400px"></div> 
			        <div id="marker_data">
				        <form id="createForm" action="/addMeetup2" method="post" accept-charset="utf-8">
				            <input type="text" name="address" id="address" class="form-control">
				            <input type="hidden" name="lat" id="lat" class="form-control">
				            <input type="hidden" name="lng" id="lng" class="form-control">
				            <button type="submit" class="btn btn-primary">Save</button>
				        </form>
				    </div>
				</div>
			</div>
		</div>
    </body>
</html>