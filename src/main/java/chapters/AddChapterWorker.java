package chapters;

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

// TODO: Auto-generated Javadoc
/**
 * The Class AddChapterWorker.
 */
public class AddChapterWorker extends HttpServlet {
	 
 	/**
 	 * doPost - Adding a new chapter entity to the Datastore. 
 	 * Takes care of updating memcache. 
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String chapterName = request.getParameter("chapterName");
	     String summary = request.getParameter("summary");
	     String userID = request.getParameter("userID");
	     String course = request.getParameter("course");
	     
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     
	     Entity chapter = new Entity("Chapters");//Removed key
	     Date date = new Date();
	     chapter.setProperty("date", date);
	     chapter.setProperty("chapterName", chapterName);
	     chapter.setProperty("user", userID);
	     chapter.setProperty("course",course);
	     chapter.setProperty("summary",summary);
	 
	     
	     datastore.put(chapter);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.put(course+chapterName+userID,chapter);
		 
		 syncCache.delete(course+userID);
	     
	    
	     
	     
	 }
	}