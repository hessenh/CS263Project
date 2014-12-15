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
 * The Class AddMeetupEq.
 */
public class AddMeetupEq extends HttpServlet {
    
    /* (non-Javadoc)
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String meetupAddress = request.getParameter("address");
	    String lat = request.getParameter("lat");
	    String lng = request.getParameter("lng");
	    
	    HttpSession session = request.getSession();
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	   
        // Add the task to the default queue.
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(withUrl("/addMeetupWorker").param("meetupName", (String) session.getAttribute("meetupName"))
        		.param("meetupInfo", (String) session.getAttribute("meetupInfo"))
        		.param("meetupDate", (String) session.getAttribute("meetupDate"))
        		.param("meetupTime", (String) session.getAttribute("meetupTime"))
        		.param("meetupAddress", meetupAddress)
        		.param("meetupLat", lat)
        		.param("meetupLng", lng)
        		.param("user", user.getUserId()));
        
        
        response.sendRedirect("/meetupList.jsp");
	    
    }
}