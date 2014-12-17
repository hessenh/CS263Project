package chapters;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


// TODO: Auto-generated Javadoc
/**
 * The Class AddChapterEq.
 */
public class AddChapterEq extends HttpServlet {
    
    /** 
     * Handles adding new chapters in the work queue. 
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String chapterName = request.getParameter("chapterName");
	    String summary = request.getParameter("summary");
	    HttpSession session = request.getSession();
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	   
        // Add the task to the default queue.
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(withUrl("/addChapterWorker").param("chapterName", chapterName).param("summary",summary).param("userID",user.getUserId()).param("course", (String) session.getAttribute("course")));
        
        
        response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
      
    }
}