package meetup;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


// TODO: Auto-generated Javadoc
/**
 * The Class addMeetup.
 */
public class addMeetup extends HttpServlet {
	 
 	/* (non-Javadoc)
 	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
 	 */
 	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	         throws ServletException, IOException {
		 
		 HttpSession session = request.getSession();
		 session.setAttribute("meetupName",request.getParameter("meetupName"));
		 session.setAttribute("meetupInfo",request.getParameter("meetupInfo"));
		 session.setAttribute("meetupDate",request.getParameter("meetupDate"));
		 session.setAttribute("meetupTime",request.getParameter("meetupTime"));
	     response.sendRedirect("/addMeetupLoc.jsp");
	     
	     }
	 }