<!DOCTYPE html>
<html>
<head>
    <title>Add meetup</title>
    <link rel="stylesheet" href="/stylesheets/boot2.css">
</head>
<body>
<jsp:include page="/navbar.jsp"></jsp:include>

<div class="container">
	<div class="row">
		<div class="col-md-10 col-lg-10">
			<h2>New meetup</h2>
			<form action="/addMeetup" method="post">
				<input type="text" name="meetupName" class="form-control" placeholder="Title"><br>
				<input type="text" name="meetupInfo" class="form-control" placeholder="Info"><br>
				<input type="date" name="meetupDate">
				<input type="time" name="meetupTime"><br>
				<button type="submit" class="btn btn-primary">Next</button>
			</form>
		</div>
	</div>
</div>


</body>
</html>