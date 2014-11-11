<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Location</title>
        <link rel="stylesheet" href="/stylesheets/bootstrap.css">
        <meta charset="utf-8">
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> 
        <script type="text/javascript">
            var map;
            var geocoder; //2a
            var initialLocation = new google.maps.LatLng(-44.6895642,169.1320571); //2
            function init() {
            	geocoder = new google.maps.Geocoder(); //2b
                var duckOptions = { //3
                    zoom: 12,
                    center: initialLocation,
                    mapTypeId: google.maps.MapTypeId.HYBRID
                };
                map = new google.maps.Map(document.getElementById("map_canvas"), duckOptions); //4
                var marker = new google.maps.Marker({ //5
                    position: initialLocation, 
                    map: map
                });
                google.maps.event.addListener(map, 'click', function(event) {
                    placeMarker(event.latLng);
                });
            }
            function placeMarker(location) {
                var marker = new google.maps.Marker({
                    position: location,
                    map: map
                });
                //3 - all code until 
                document.getElementById('longitude').value=location.lng();
                document.getElementById('latitude').value=location.lat();
                //$("#longitude").val(location.lng());  
               //$("#latitude").val(location.lat());
                
                geocoder.geocode( { 'latLng': location}, function(results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                    	document.getElementById('gaddress').value=results[0].formatted_address;
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
        <h1>Choose location</h1>
        <div id="map_canvas" style="width:50%;height:400px"></div> 
        <div id="marker_data">
	        <form id="createForm" action="/new" method="post" accept-charset="utf-8">
	            <table>
	                <tr>
	                    <td>Title</td>
	                    <td><input type="text" name="title" id="title" size="66"/></td>
	                </tr>
	                <tr>
	                    <td>Description</td>
	                    <td><textarea rows="4" cols="50" name="description"    id="description"></textarea>
	                </tr>
	                <tr>
	                    <td>Latitude</td>
	                    <td><input type="text" name="latitude" id="latitude" size="66" /></td>
	                </tr>
	                <tr>
	                    <td>Longitude</td>
	                    <td><input type="text" name="longitude" id="longitude" size="66" /></td>
	                </tr>
	                <tr>
	                    <td>Address</td>
	                    <td><input type="text" name="gaddress" id="gaddress" size="66" /></td>
	                </tr>
	            </table><br/><br/>
	            <input type="submit" value="Save"/>
	        </form>
	    </div>
    </body>
</html>