package twitter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;

// TODO: Auto-generated Javadoc
/**
 * The Class LogoutServlet.
 */
public class LogoutServlet extends HttpServlet {
    
    /** The Constant serialVersionUID. */
    private static final long serialVersionUID = -4433102460849019660L;

    /**
 	 * doGet - Logout from twitter
 	 *
 	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath()+ "/");
    }
}