package chapters;

import java.io.IOException;
import java.util.Date;

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
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class EditChapter extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
		 
		 String chapterName = request.getParameter("cName");
	     String chapterSummary = request.getParameter("cSummary");
	     
	     System.out.println(request.getParameterNames().toString());
	     System.out.println(chapterName);
	     
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	 	
	     HttpSession session = request.getSession();
	     System.out.println("hei");
	     
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
	     response.sendRedirect("/viewChapter.jsp?chapterName=" + session.getAttribute("chapter"));
	     
	     
	 }
	}