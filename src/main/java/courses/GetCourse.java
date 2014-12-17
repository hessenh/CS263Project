package courses;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;

// TODO: Auto-generated Javadoc
/**
 * The Class GetCourse.
 */
public class GetCourse extends HttpServlet {
    
	/**
 	 * Only used to redirect user.
 	 * 
 	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String course = request.getParameter("courseName");
        System.out.println(course);
        // Add the task to the default queue.

        //response.sendRedirect("/done.html");
        response.sendRedirect("/viewCourse.jsp?courseName=" + course);
        //response.sendRedirect("/blob.jsp");
        //response.sendRedirect("/test");
    }
}