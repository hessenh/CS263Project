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

// TODO: Auto-generated Javadoc
/**
 * The Class AddQuestionWorker.
 */
public class AddQuestionWorker extends HttpServlet {
	 
 	/* (non-Javadoc)
 	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String questionTitle = request.getParameter("questionTitle");
	     String questionInfo = request.getParameter("questionInfo");
	     String userID = request.getParameter("userID");
	     
	     
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	     Entity question = new Entity("Questions");//Removed key
	     Date date = new Date();
	     question.setProperty("date", date);
	     question.setProperty("questionTitle", questionTitle);
	     question.setProperty("questionInfo", questionInfo);
	     question.setProperty("userId",userID);
	 
	     
	     datastore.put(question);
	     
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 syncCache.put(questionTitle+questionInfo,question);
		 
		 syncCache.delete("questions");
	     
	    
	     
	     
	 }
	}