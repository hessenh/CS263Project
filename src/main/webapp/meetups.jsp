<!DOCTYPE html>
<%@page import="twitter4j.conf.Configuration"%>
<%@page import="twitter4j.conf.ConfigurationBuilder"%>
<%@page import="twitter4j.TwitterException"%>
<%@page import="java.util.List"%>
<%@page import="twitter4j.Status"%>
<%@page import="twitter4j.QueryResult"%>
<%@page import="twitter4j.Query"%>
<%@page import="twitter4j.TwitterFactory"%>
<%@page import="twitter4j.Twitter"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<div class="jumbotron meetup">
				<h2>Meetups!</h2>
				<p>Find out if there is a meetup or start a new meetup!</p>
				<p><a class="btn btn-primary btn-lg" href="/meetupList.jsp">Continue!</a></p>
			</div>	
			<h3>Twitter</h3>
		</div>
	</div>
</div>


<%
ConfigurationBuilder builder = new ConfigurationBuilder();

builder.setOAuthAccessToken("310273362-huWbROL2e1JbIFtV5nLalXF7VNFqh45MxY2i7lIN");
builder.setOAuthAccessTokenSecret("cIkzguvKzFSY2HqVvI46JbeF4Pmt7mXxYlKDLavXL3WUg");
builder.setOAuthConsumerKey("vh4vHyTPlYJniTtJMJLAKNwWx");
builder.setOAuthConsumerSecret("UgG2KDFoiPUQsnFiGLO5dAdzeO7YZaVuq4zvcQHPy4iAulyIP9");
Configuration configuration = builder.build();

TwitterFactory tf = new TwitterFactory(configuration);
Twitter twitter = tf.getInstance();

Query query = new Query("CS263Project");
QueryResult result = null;
try {
	result = twitter.search(query);
} catch (TwitterException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
List<Status> tweetList = result.getTweets();

if(!tweetList.isEmpty()){
	for (Status status : tweetList){
        pageContext.setAttribute("twitterUser","@" + status.getUser().getScreenName());
        pageContext.setAttribute("twitterText",status.getText());
%>
<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<div class="jumbotron meetup">
				<h3>${fn:escapeXml(twitterUser)}</h3>
				<p>${fn:escapeXml(twitterText)}</p>
			</div>
		</div>
	</div>
</div>
<%
	}
}
%>

</body>
</html>