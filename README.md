##CS236 Project

http://hansolahucsb.appspot.com/ 

The package called "queuesAndWorkers" are not in use in the online application now. This is mainly b/c of the site is redirecting the user back before the workers have updated the datastore. I have chosen to have the implimentation without the queues for now. If this application is going to scale up, it would be easy to implement these changes. 

## Skeleton application for use with App Engine Java.

Requires [Apache Maven](http://maven.apache.org) 3.0 or greater, and JDK 6+ in order to run.

To build, run

    mvn package

Building will run the tests, but to explicitly run tests you can use the test target

    mvn test

To start the app, use the [App Engine Maven Plugin](http://code.google.com/p/appengine-maven-plugin/) that is already included in this demo.  Just run the command.

    mvn appengine:devserver

For further information, consult the [Java App Engine](https://developers.google.com/appengine/docs/java/overview) documentation.

To see all the available goals for the App Engine plugin, run

    mvn help:describe -Dplugin=appengine





###Todo:
####Course
- Adding - Done
- UI - Done
- Memcach - Done
- QandW

####Chapters
- Adding/delete/update - Done
- UI - Done
- Memcache - Done
- QandW

####Task
- Adding/delete/update - Done
- UI - Done
- Memcache - Done
- Blobstore - Done
- QandW

####Discuss
- UI - Done
- Adding - Done
- Commenting - Done 
- Memcache - Done
- QandW

####Meetup
- Ui - Done
- Create - Done
- View - Done
- Memcache - Done
- QandW



