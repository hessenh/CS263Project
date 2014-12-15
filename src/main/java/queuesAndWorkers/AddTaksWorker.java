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

public class AddTaksWorker extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String taskName = request.getParameter("taskName");
	     String taskInfo = request.getParameter("taskInfo");
	     String user = request.getParameter("userID");
	     String course = request.getParameter("course");
	     String file = request.getParameter("file");
	     
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     Entity task = new Entity("Tasks");//Removed key
	     Date date = new Date();
	     task.setProperty("date", date);
	     task.setProperty("taskName", taskName);
	     task.setProperty("user", user);
	     task.setProperty("course",course);
	     task.setProperty("taskInfo",taskInfo);
	     task.setProperty("file",file);
	 
	     
	     datastore.put(task);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 
		 syncCache.put(course+taskName+user,task);
		 syncCache.delete(course+user+"task");
		 
		 System.out.println("Putting " + taskName + " in memcache, with key: "+course+taskName+user+" . Deleting tasklist from memcache");
	  
	     
	     
	 }
	}