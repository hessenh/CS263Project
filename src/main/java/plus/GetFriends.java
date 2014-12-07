package plus;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import com.googlecode.googleplus.GooglePlusException;

public class GetFriends {

	
	@SuppressWarnings("deprecation")
	public GetFriends() {
		final String API_KEY = "AIzaSyBz4gRJfxibgeRDRF7iGgPgjm9QmhVMIjM";
		final String USERID = "105126589263689495700";
		String json = "";
		GetFriends result = null;
		
		try {
			
			// Open a connection to the URL at our URI API request string
			URLConnection gpAPI = new URL( "https://www.googleapis.com/plus/v1/people/" + USERID + "?key=" + API_KEY ).openConnection();
			// Declare an HTTPURLConnection resource, used to get the response code (and in the error case, evaluate)
			HttpURLConnection gpConnection = ( ( HttpURLConnection ) gpAPI );
			
			// Determine if the request was a success (Code 200)
			if( gpConnection.getResponseCode() != 200 ){
			
				// Request was not successful, pull error message from the server
				BufferedReader reader = new BufferedReader( new InputStreamReader( gpConnection.getErrorStream() ) );
				
				String input;
				while( ( input = reader.readLine() ) != null )
					json += input;
				
				reader.close();
				// Generate a custom exception that parses the JSON output and displays to the user
				throw new Exception( json );
			}
			
		}catch( GooglePlusException e ){
			System.out.println(e.getMessage());
		}catch( Exception e ){
			System.out.println( "Google+ API Fatal Error: " + e.getMessage() );
		}
		
		System.out.println(result);
	}

}