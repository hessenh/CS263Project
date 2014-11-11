package meetup;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class addMeetup extends HttpServlet {
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