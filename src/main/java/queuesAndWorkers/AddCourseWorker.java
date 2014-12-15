package queuesAndWorkers;

import java.io.IOException;
import java.util.Date;
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

public class AddCourseWorker extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String userID = request.getParameter("userID");
	     String courseName = request.getParameter("courseName");
	     
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     Entity course = new Entity("Courses");//Removed key
	     Date date = new Date();
	     course.setProperty("date", date);
	     course.setProperty("courseName", courseName);
	     course.setProperty("user", userID);
	 
	     
	     datastore.put(course);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.delete(userID);
	     
	 }
	}