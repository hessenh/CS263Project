package tasks;

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

public class EditTask extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
		 
		 HttpSession session = request.getSession();
		 UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	     
	     String taskName = request.getParameter("taskName");
	     String taskInfo = request.getParameter("taskInfo");
		 
	     //Memcache
	     MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
	     String key = session.getAttribute("course")+taskName+user.getUserId();
	     
		 //Update chapter
		 if(request.getParameter("save") != null){
		     Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		     Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		     Filter taskFilter = new FilterPredicate("taskName",FilterOperator.EQUAL,session.getAttribute("task"));
		     
		     Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter).setFilter(taskFilter);
		     PreparedQuery pq = ds.prepare(q);
		     Entity taskEntity= pq.asSingleEntity();
		     
		     if(!taskName.equals(null)){
		    	 taskEntity.setProperty("taskName",taskName);
		     }
		     if(!taskInfo.equals(null)){
		    	 taskEntity.setProperty("taskInfo",taskInfo);
		     }	     
		     ds.put(taskEntity);
		     System.out.println("Putting new version of task in memcache with key: " + key);
			 syncCache.put(key,taskEntity);
		     syncCache.delete(session.getAttribute("course")+user.getUserId()+"task");
		     response.sendRedirect("/viewTask.jsp?taskName=" + taskName);
		 }
		 else if(request.getParameter("delete") != null){
			 Filter courseFilter =new FilterPredicate("course",FilterOperator.EQUAL,session.getAttribute("course"));
		     Filter userFilter = new FilterPredicate("user",FilterOperator.EQUAL,user.getUserId());
		     Filter taskFilter = new FilterPredicate("taskName",FilterOperator.EQUAL,session.getAttribute("task"));
		     
		     Query q = new Query("Tasks").setFilter(userFilter).setFilter(courseFilter).setFilter(taskFilter);
		     PreparedQuery pq = ds.prepare(q);
		     Entity taskEntity= pq.asSingleEntity();
		     
		     ds.delete(taskEntity.getKey());
		     syncCache.delete(key);
		     //Remove from chapterlist also..
		     syncCache.delete(session.getAttribute("course")+user.getUserId()+"task");
		     
			 response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
		 }
		 else{
			 response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
		 }
	 }
	}