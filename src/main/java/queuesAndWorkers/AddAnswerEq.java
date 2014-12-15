package queuesAndWorkers;

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
 * The Class AddAnswerEq.
 */
public class AddAnswerEq extends HttpServlet {
    
    /* (non-Javadoc)
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	
    	String answer = request.getParameter("answer");
    	
	    
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	   
        // Add the task to the default queue.
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(withUrl("/addQuestionAnswer").param("answer", answer).param("userID",user.getUserId()).param("questionTitle", (String) session.getAttribute("questionTitle")).param("questionInfo", (String) session.getAttribute("questionInfo")));
        
        
        response.sendRedirect("/viewQuestion.jsp?questionTitle=" + session.getAttribute("questionTitle"));
      
    }
}