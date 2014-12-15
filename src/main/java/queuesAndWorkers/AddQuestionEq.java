package queuesAndWorkers;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


// TODO: Auto-generated Javadoc
/**
 * The Class AddQuestionEq.
 */
public class AddQuestionEq extends HttpServlet {
    
    /* (non-Javadoc)
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String questionTitle = request.getParameter("questionTitle");
	    String questionInfo = request.getParameter("questionInfo");
	    
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	   
	   
        // Add the task to the default queue.
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(withUrl("/addQuestionWorker").param("questionTitle", questionTitle).param("questionInfo",questionInfo).param("userID",user.getUserId()));
        
        
        response.sendRedirect("/viewQuestion.jsp?questionTitle=" + questionTitle);
      
    }
}