package tasks;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.files.dev.Session;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class AddTask extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String taskName = request.getParameter("taskName");
	     String taskInfo = request.getParameter("taskInfo");
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     
	     HttpSession session = request.getSession();
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    ;
	 
	     Entity task = new Entity("Tasks");//Removed key
	     Date date = new Date();
	     task.setProperty("date", date);
	     task.setProperty("taskName", taskName);
	     task.setProperty("user", user.getUserId());
	     task.setProperty("course",session.getAttribute("course"));
	     task.setProperty("taskInfo",taskInfo);
	 
	     
	     datastore.put(task);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.put(session.getAttribute("course")+taskName+user.getUserId(),task);
		 
		 syncCache.delete(session.getAttribute("course")+user.getUserId()+"task");
		 System.out.println("Putting " + taskName + " in memcache. Deleting tasklist from memcache");
	     
	     response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
	     
	     
	 }
	}