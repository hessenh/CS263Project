package Memcache;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;

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
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;




public class ReadEntity extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse resp)
	         throws ServletException, IOException {
		 String res = null;
		 String key = request.getParameter("content");
		 String value;
		 
		 //Setting up the memcache
		 MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		 syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		 value = (String) syncCache.get(key); // read from cache
		 if (value == null) {
			 DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			 Key qkey = KeyFactory.createKey("TaskData",key);
			 Query q = new Query(qkey);
			 List<Entity> result = ds.prepare(q).asList(FetchOptions.Builder.withLimit(5));
			 for(Entity e:result){
				 res = (String) e.getProperty("value");
			 }
			 resp.setContentType("text/html");
		     PrintWriter out = resp.getWriter();
		     out.print("<h1>" + res + " key " + key + " was not in memcache, but it's there now!</h>");
			 //System.out.println(res);
			 //System.out.println(key);
			 System.out.println("Not in memcache");
			 if(res != null){
				 syncCache.put(key, res); // populate cache
			 }
		 }
		 else{
			 resp.setContentType("text/html");
		     PrintWriter out = resp.getWriter();
		     out.print("<h1>" + value + " was in memcache!</h>");
			 //System.out.println(value);
			 //System.out.println("In memcache");
		 }
		 
		 
		 
	     
	 }
}
