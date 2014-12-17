package tasks;

import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
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
 * The Class AddTask.
 */
@SuppressWarnings("serial")
public class AddTask extends HttpServlet {
	
	/** The blobstore service. */
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	/**
 	 * doPost - Adding a new task in the datastore. 
 	 * Handles the file given by the user.
 	 * Takes care of updating memcache. 
 	 */
 	@SuppressWarnings("deprecation")
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String taskName = request.getParameter("taskName");
	     String taskInfo = request.getParameter("taskInfo");
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     
	     HttpSession session = request.getSession();
	     
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     //Blobstore
	     Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
	     BlobKey blobKey = blobs.get("myFile");
	 
	     Entity task = new Entity("Tasks");
	     Date date = new Date();
	     task.setProperty("date", date);
	     task.setProperty("taskName", taskName);
	     task.setProperty("user", user.getUserId());
	     task.setProperty("course",session.getAttribute("course"));
	     task.setProperty("taskInfo",taskInfo);
	     task.setProperty("file",blobKey.getKeyString());
	 
	     
	     datastore.put(task);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 
		 syncCache.put(session.getAttribute("course")+taskName+user.getUserId(),task);
		 syncCache.delete(session.getAttribute("course")+user.getUserId()+"task");
		 
		 System.out.println("Putting " + taskName + " in memcache, with key: "+session.getAttribute("course")+taskName+user.getUserId()+" . Deleting tasklist from memcache");
	     
	     response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
	     
	     
	 }
	}