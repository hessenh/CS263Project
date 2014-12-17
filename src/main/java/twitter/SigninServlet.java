package twitter;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.RequestToken;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// TODO: Auto-generated Javadoc
/**
 * The Class SigninServlet.
 */
public class SigninServlet extends HttpServlet {
    
    /** The Constant serialVersionUID. */
    private static final long serialVersionUID = -6205814293093350242L;

    /**
 	 * doGet - Sign in with twitter 
 	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Twitter twitter = new TwitterFactory().getInstance();
        request.getSession().setAttribute("twitter", twitter);
        try {
            StringBuffer callbackURL = request.getRequestURL();
            int index = callbackURL.lastIndexOf("/");
            callbackURL.replace(index, callbackURL.length(), "").append("/callback");

            RequestToken requestToken = twitter.getOAuthRequestToken(callbackURL.toString());
            request.getSession().setAttribute("requestToken", requestToken);
            response.sendRedirect(requestToken.getAuthenticationURL());
//            response.sendRedirect("/SignInTwitter.jsp");
        } catch (TwitterException e) {
            throw new ServletException(e);
        }

    }
}