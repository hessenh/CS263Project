package chapters;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.datastore.DatastoreService;


import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class EditChapter extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
		 
		 HttpSession session = request.getSession();
		 UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	     String chapterName = request.getParameter("cName");
	     String chapterSummary = request.getParameter("cSummary");
		 
	     //Memcache
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	     String key = session.getAttribute("course")+chapterName+user.getUserId();
	     
		 //Update chapter
		 if(request.getParameter("save") != null){
		     Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		     Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		     Filter chapterFilter = new FilterPredicate("chapterName",FilterOperator.EQUAL,session.getAttribute("chapter"));
		     Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter).setFilter(chapterFilter);
		     PreparedQuery pq = ds.prepare(q);
		     Entity chapterEntity= pq.asSingleEntity();
		     if(!chapterName.equals(null)){
		    	 chapterEntity.setProperty("chapterName",chapterName);
		     }
		     if(!chapterSummary.equals(null)){
		    	 chapterEntity.setProperty("summary",chapterSummary);
		     }	     
		     ds.put(chapterEntity);
			 syncCache.put(key,chapterEntity);
			 syncCache.delete(session.getAttribute("course")+user.getUserId());
			 syncCache.delete(session.getAttribute("course")+""+session.getAttribute("chapter")+ user.getUserId());
		     
		     response.sendRedirect("/viewChapter.jsp?chapterName=" + chapterName);
		 }
		 else if(request.getParameter("delete") != null){
			 Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		     Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		     Filter chapterFilter = new FilterPredicate("chapterName",FilterOperator.EQUAL,session.getAttribute("chapter"));
		     Query q = new Query("Chapters").setFilter(userFilter).setFilter(courseFilter).setFilter(chapterFilter);
		     PreparedQuery pq = ds.prepare(q);
		     Entity chapterEntity= pq.asSingleEntity();
		     
		     ds.delete(chapterEntity.getKey());
		     syncCache.delete(key);
		     //Remove from chapterlist also..
		     syncCache.delete(session.getAttribute("course")+user.getUserId());
		     
			 response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
		 }
		 else{
			 response.sendRedirect("/viewChapter.jsp?chapterName=" + session.getAttribute("chapter"));
		 }
	 }
	}