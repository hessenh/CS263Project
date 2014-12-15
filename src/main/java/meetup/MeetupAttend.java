package meetup;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

// TODO: Auto-generated Javadoc
/**
 * The Class MeetupAttend.
 */
public class MeetupAttend extends HttpServlet {
	 
 	/* (non-Javadoc)
 	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     
	     HttpSession session = request.getSession();
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     if(request.getParameter("attend")!=null){
	    	 Entity meetupAttend = new Entity("MeeupAttending");
		     
		     meetupAttend.setProperty("meetupName", session.getAttribute("meetupName"));
		     meetupAttend.setProperty("username", user.getNickname());
		     meetupAttend.setProperty("userId", user.getUserId());
		 
		     datastore.put(meetupAttend);
	     }
	     else{
	    	 
	    	 Filter meetupFilter = new FilterPredicate("meetupName",FilterOperator.EQUAL,session.getAttribute("meetupName"));
	    	 Filter userFilter = new FilterPredicate("userId",FilterOperator.EQUAL,user.getUserId());
	    	 Query q = new Query("MeeupAttending").setFilter(meetupFilter).setFilter(userFilter);
	    	 PreparedQuery pq = datastore.prepare(q);
				
	    	 Entity meetupAttend = pq.asSingleEntity();
	    	 datastore.delete(meetupAttend.getKey());
	     }
	     
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.delete(session.getAttribute("meetupName")+"parList");
		 
	     response.sendRedirect("/viewMeetup.jsp?meetupName="+session.getAttribute("meetupName"));
	     
	     
	 }
	}