package queuesAndWorkers;

import static com.google.appengine.api.taskqueue.TaskOptions.Builder.withUrl;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


// TODO: Auto-generated Javadoc
/**
 * The Class AddTaksEq.
 */
public class AddTaksEq extends HttpServlet {
	
	/** The blobstore service. */
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
    /* (non-Javadoc)
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String taskName = request.getParameter("taskName");
	    String taskInfo = request.getParameter("taskInfo");
	     
	    HttpSession session = request.getSession();
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	    //Blobstore
	    Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
	    BlobKey blobKey = blobs.get("myFile");
	   
        // Add the task to the default queue.
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(withUrl("/addTaskWorker")
        		.param("taskName", taskName)
        		.param("taskInfo",taskInfo)
        		.param("userID",user.getUserId())
        		.param("course", (String) session.getAttribute("course"))
        		.param("file", blobKey.getKeyString()));
        
        
        response.sendRedirect("/viewCourse.jsp?courseName=" + session.getAttribute("course"));
	         
    }
}