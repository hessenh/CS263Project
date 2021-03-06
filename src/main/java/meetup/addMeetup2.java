package meetup;

import java.io.IOException;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

// TODO: Auto-generated Javadoc
/**
 * The Class addMeetup2.
 */
@SuppressWarnings("serial")
public class addMeetup2 extends HttpServlet {
	 
	/**
 	 * doPost - Adding a new meetup in the Datastore
 	 * Takes care of updating memcache. 
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String meetupAddress = request.getParameter("address");
	     String lat = request.getParameter("lat");
	     String lng = request.getParameter("lng");
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     HttpSession session = request.getSession();
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     Entity meetup = new Entity("Meetups");
	     
	     meetup.setProperty("meetupName", session.getAttribute("meetupName"));
	     meetup.setProperty("meetupInfo", session.getAttribute("meetupInfo"));
	     meetup.setProperty("meetupDate", session.getAttribute("meetupDate"));
	     meetup.setProperty("meetupTime", session.getAttribute("meetupTime"));
	     meetup.setProperty("meetupAddress", meetupAddress);
	     meetup.setProperty("meetupLat", lat);
	     meetup.setProperty("meetupLng", lng);
	     meetup.setProperty("user", user.getUserId());
	 
//	     confTwitter twitter = new confTwitter();
	     
	     datastore.put(meetup);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.delete("meetups");
		 
	     response.sendRedirect("/meetupList.jsp");
	     
	     
	 }
	}