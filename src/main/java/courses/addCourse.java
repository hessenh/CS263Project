package courses;

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
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class addCourse extends HttpServlet {
	 protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
	     String courseName = request.getParameter("courseName");
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     
	     // Do something with key.
	     DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	     Key courseKey = KeyFactory.createKey("Courses",user.getUserId());
	     Entity course = new Entity(courseKey);
	     Date date = new Date();
	     course.setProperty("date", date);
	     course.setProperty("courseName", courseName);
	 
	     
	     datastore.put(course);
	     response.sendRedirect("/courses.jsp");
	     
	     
	 }
	}