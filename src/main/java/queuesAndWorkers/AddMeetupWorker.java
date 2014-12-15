package queuesAndWorkers;

import java.io.IOException;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

// TODO: Auto-generated Javadoc
/**
 * The Class AddMeetupWorker.
 */
public class AddMeetupWorker extends HttpServlet {
	 
 	/* (non-Javadoc)
 	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     
		 
		 
		 DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     Entity meetup = new Entity("Meetups");
	     
	     meetup.setProperty("meetupName", request.getParameter("meetupName"));
	     meetup.setProperty("meetupInfo", request.getParameter("meetupInfo"));
	     meetup.setProperty("meetupDate", request.getParameter("meetupDate"));
	     meetup.setProperty("meetupTime", request.getParameter("meetupTime"));
	     meetup.setProperty("meetupAddress", request.getParameter("meetupAddress"));
	     meetup.setProperty("meetupLat", request.getParameter("meetupLat"));
	     meetup.setProperty("meetupLng", request.getParameter("meetupLng"));
	     meetup.setProperty("user", request.getParameter("user"));
	     
	     datastore.put(meetup);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.delete("meetups");
	     
	     
	 }
	}