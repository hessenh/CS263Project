package discuss;

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

public class addAnswer extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String answer = request.getParameter("answer");
	    
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     HttpSession session = request.getSession();
	     
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	     Entity questionAnswer = new Entity("QuestionAnswer");//Removed key
	     Date date = new Date();
	     questionAnswer.setProperty("date", date);
	     questionAnswer.setProperty("questionTitle", session.getAttribute("questionTitle"));
	     questionAnswer.setProperty("questionInfo", session.getAttribute("questionInfo"));
	     questionAnswer.setProperty("answer",answer);
	     questionAnswer.setProperty("userId",user.getUserId());
	 
	     
	     datastore.put(questionAnswer);
	     
//	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
//		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
//		 syncCache.put(session.getAttribute("course")+chapterName+user.getUserId(),chapter);
//		 
//		 syncCache.delete(session.getAttribute("course")+user.getUserId());
	     
	     response.sendRedirect("/viewQuestion.jsp?questionTitle=" + session.getAttribute("questionTitle"));
	     
	     
	 }
	}