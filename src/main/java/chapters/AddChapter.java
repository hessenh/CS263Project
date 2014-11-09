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

public class AddChapter extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String chapterName = request.getParameter("chapterName");
	     String summary = request.getParameter("summary");
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     
	     HttpSession session = request.getSession();
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     //Key courseKey = KeyFactory.createKey("Courses",user.getUserId());
	     Key userKey = KeyFactory.createKey("Chapters",user.getUserId());
	     Entity chapter = new Entity("Chapters");//Removed key
	     Date date = new Date();
	     chapter.setProperty("date", date);
	     chapter.setProperty("chapterName", chapterName);
	     chapter.setProperty("user", user.getUserId());
	     chapter.setProperty("course",session.getAttribute("course"));
	     chapter.setProperty("summary",summary);
	 
	     
	     datastore.put(chapter);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.put(session.getAttribute("course")+chapterName+user.getUserId(),chapter);
		 
		 syncCache.delete(session.getAttribute("course")+user.getUserId());
	     
	     response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
	     
	     
	 }
	}