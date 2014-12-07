package plus;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;

import org.json.JSONException;
import org.json.JSONObject;





public class notifyGooglePlus {


	public notifyGooglePlus() {
		final String API_KEY = "AIzaSyBz4gRJfxibgeRDRF7iGgPgjm9QmhVMIjM";
		final String USERID = "105126589263689495700";
		
		try {
			System.out.println("WHAT??????");
			JSONObject json = readJsonFromUrl("https://www.googleapis.com/plus/v1/people?query=madhu.kodam&key=AIzaSyBz4gRJfxibgeRDRF7iGgPgjm9QmhVMIjM");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
        
        // Google+ API Example.  
        doGooglePlus(USERID);  
	}
	
	 public static void doGooglePlus(String USERID){  
         
	        // Initialize the Google+ API.  
	        GooglePlusAPI gpAPI = new GooglePlusAPI();  
	          
	        // Load our public user object.  
	        // DEFAULT_GOOGLEPLUS_UID is set in the beginning of this class as a constant.  
	        // Defaults to Shane Chism's Google+ page;  
	        // To change, replace DEFAULT_GOOGLEPLUS_UID with a string containing a Google+ User ID number.  
	        GP_PublicUser user = gpAPI.get( USERID );  
	          
	        // Output the data we've received from our API GET request!  
	        printHeader( "Google+ API Results" );  
	        System.out.println(user.getId());  
	        System.out.println(user.getOrganizations());  
	        System.out.println( "Google Plus Full Name: " + user.getDisplayName() );  
	        System.out.println( "Google Plus Full Name: " + user.getAboutMe());  
	        System.out.println( "Google Plus Full Name: " + user.getGender() );  
	        System.out.println( "Google Plus Full Name: " + user.getTagline() );  
	        System.out.println( "Google Plus Full Name: " + user.getURL() );  
	        System.out.println( "Google Plus Full Name: " + user.getImage());  
	        System.out.println(user.getPlacesLived());  
	          
	        // The Google+ API only returns the full name, so to match the Facebook API let's go ahead and cut  
	        // the string off at the first occurrence of a space (the ' ' character).  
	        String userFirstName = user.getDisplayName().substring( 0, user.getDisplayName().indexOf(' ') );  
	        System.out.println( "See " + userFirstName +"");  
	    System.out.println( "See " + userFirstName + "'s Profile Here: " + user.getURL() + "\n" );  
	          
	        // Print out the user's publicly listed URLs.  
	        // (This is a good example of iterating through user data which contains multiple records)  
	    /* for( Map<String,String> url : user.getURLs() ) 
	            System.out.println( "One of " + userFirstName + "'s URLs: " + url.get( "value" ) ); 
	    */  
	    }  
	      
	    public static void printHeader( String str ){  
	        System.out.println( "\n============== " + str + " ==============\n" );  
	    }  
	  
	     public static JSONObject readJsonFromUrl(String url) throws IOException, JSONException {  
	            InputStream is = new URL(url).openStream();  
	            try {  
	              BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));  
	                
	              String jsonText = readAll(rd);  
	              JSONObject json = new JSONObject(jsonText);  
	              System.out.println("json--"+json);  
	              System.out.println(json.getJSONArray("items").getJSONObject(0).get("displayName"));  
	              System.out.println(json.getJSONArray("items").getJSONObject(0).get("url"));  
	              return json;  
	            } finally {  
	              is.close();  
	            }  
	          }  
	  
	     private static String readAll(Reader rd) throws IOException {  
	            StringBuilder sb = new StringBuilder();  
	            int cp;  
	            while ((cp = rd.read()) != -1) {  
	              sb.append((char) cp);  
	            }  
	            return sb.toString();  
	          }  

}