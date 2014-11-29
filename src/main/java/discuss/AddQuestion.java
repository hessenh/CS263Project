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

public class AddQuestion extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String questionTitle = request.getParameter("questionTitle");
	     String questionInfo = request.getParameter("questionInfo");
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	     Entity question = new Entity("Questions");//Removed key
	     Date date = new Date();
	     question.setProperty("date", date);
	     question.setProperty("questionTitle", questionTitle);
	     question.setProperty("questionInfo", questionInfo);
	     question.setProperty("userId",user.getUserId());
	 
	     
	     datastore.put(question);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.put(questionTitle+questionInfo,question);
		 
		 syncCache.delete("questions");
	     
	     response.sendRedirect("/viewQuestion.jsp?questionTitle=" + questionTitle);
	     
	     
	 }
	}