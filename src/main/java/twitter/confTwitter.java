package twitter;

import java.util.List;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.Configuration;
import twitter4j.conf.ConfigurationBuilder;

public class confTwitter {
	private Twitter twitter;

	public confTwitter() {
		ConfigurationBuilder builder = new ConfigurationBuilder();
//		cb.setDebugEnabled(true)
		
		builder.setOAuthAccessToken("310273362-huWbROL2e1JbIFtV5nLalXF7VNFqh45MxY2i7lIN");
		builder.setOAuthAccessTokenSecret("cIkzguvKzFSY2HqVvI46JbeF4Pmt7mXxYlKDLavXL3WUg");
		builder.setOAuthConsumerKey("vh4vHyTPlYJniTtJMJLAKNwWx");
		builder.setOAuthConsumerSecret("UgG2KDFoiPUQsnFiGLO5dAdzeO7YZaVuq4zvcQHPy4iAulyIP9");
		Configuration configuration = builder.build();
		
		TwitterFactory tf = new TwitterFactory(configuration);
		Twitter twitter = tf.getInstance();
		
	    Query query = new Query("NTNU");
	    QueryResult result;
		try {
			result = twitter.search(query);
			for (Status status : result.getTweets()) {
		        System.out.println("@" + status.getUser().getScreenName() + ":" + status.getText());
		    }
		} catch (TwitterException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
		
	}
	public Twitter getTwitter(){
		return this.twitter;
	}
	
}
