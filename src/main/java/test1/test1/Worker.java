package test1.test1;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

//The Worker servlet should be mapped to the "/worker" URL.
public class Worker extends HttpServlet {
 protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
     String value = request.getParameter("value");
     String name = request.getParameter("name");
   
     // Do something with key.
     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
     Key taskKey = KeyFactory.createKey("TaskData", value);
     Entity task = new Entity(taskKey);
     Date inData = new Date();
     task.setProperty("date", inData);
     task.setProperty("value", name);
 
     
     datastore.put(task);
     
     
 }
}