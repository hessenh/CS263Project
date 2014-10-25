package test1.test1;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;

public class ReadData extends HttpServlet {
	 protected void doGet(HttpServletRequest request, HttpServletResponse resp)
	         throws ServletException, IOException {
		 System.out.println("hei");
		 resp.setContentType("text/html");
	     PrintWriter out = resp.getWriter();

	     DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	     Query q = new Query("TaskData");
	     PreparedQuery pq = ds.prepare(q);  
	     
	     out.print("<h1>Here is all the entities in TaskData</h>");
	     
	     for(Entity result : pq.asIterable()){
	    	 Key key = result.getKey();
	    	 String value = (String) result.getProperty("value");
	    	 Date date = (Date) result.getProperty("date");
	    	 out.print("<h2>" + key + " - " +value + " - " + date + "</h2>" + "<br>");
	     }
	     
	     
	     
	 }
}
