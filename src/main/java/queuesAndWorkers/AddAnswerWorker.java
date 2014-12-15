package queuesAndWorkers;

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
 * The Class AddAnswerWorker.
 */
public class AddAnswerWorker extends HttpServlet {
	 
 	/* (non-Javadoc)
 	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String answer = request.getParameter("answer");
	     String questionTitle = request.getParameter("questionTitle");
	     String questionInfo = request.getParameter("questionInfo");
	     String userID = request.getParameter("userID");
	     
	     Entity questionAnswer = new Entity("QuestionAnswer");//Removed key
	     Date date = new Date();
	     questionAnswer.setProperty("date", date);
	     questionAnswer.setProperty("questionTitle",questionTitle );
	     questionAnswer.setProperty("questionInfo", questionInfo);
	     questionAnswer.setProperty("answer",answer);
	     questionAnswer.setProperty("userId",userID);
	 
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     datastore.put(questionAnswer);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 
		 syncCache.delete(questionTitle+"answer");
	     
	    
	     
	     
	 }
	}