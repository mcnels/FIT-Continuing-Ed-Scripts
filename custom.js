// Set cache settings
var meta = document.createElement('meta');
meta.httpEquiv = "Cache-Control";
meta.content = "no-cache, no-store, must-revalidate";
document.getElementsByTagName('head')[0].appendChild(meta);

var meta1 = document.createElement('meta');
meta1.httpEquiv = "Pragma";
meta1.content = "no-cache";
document.getElementsByTagName('head')[0].appendChild(meta1);

var meta2 = document.createElement('meta');
meta2.httpEquiv = "Expires";
meta2.content = "0";
document.getElementsByTagName('head')[0].appendChild(meta2);

// Get logged in user's id
var loggedinUser = "";
userExists = false;
if (window.location.href == 'https://fit.test.instructure.com/courses/533668') {
  loggedinUser = ENV.current_user.id;
  //userExists = true;
  // --- test ---
  console.log("user id:" + loggedinUser);
  //if (userExists) {
    // Create a request variable and assign a new XMLHttpRequest object to it.
    var students = new XMLHttpRequest();

    // Open a new connection, using the GET request on the URL endpoint
    //students.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/students', true);
    students.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/quizzes/830697/submissions', true);
    // Add authorization
    students.setRequestHeader("Authorization", "Bearer 1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj");
    // Send request
    students.send();

    // Do this with response...
    students.onload = function () {
      var data = JSON.parse(this.response);
      console.log(data.quiz_submissions);
      var submdate = "";
      var i;
      // save ids and submission dates from response in an array
      for (i = 0; i < data.quiz_submissions.length; i++) {
        // --- test ---
        console.log(`i: ${i}, user: ${data.quiz_submissions[i].user_id}`);
        if (data.quiz_submissions[i].user_id == loggedinUser) {
          // --- test ---
          console.log(data.quiz_submissions[i].user_id);

          submdate = data.quiz_submissions[i].finished_at;

          // --- test ---
          console.log(data.quiz_submissions[i].finished_at);

        }
      }
    }

    // find deadline
    var tt = submdate; // formatted as mm/dd/yyyy

    var date = new Date(tt); // submdate
    var newdate = new Date(date); //deadline

    newdate.setDate(newdate.getDate() + 180);

    var dd = newdate.getDate();
    var mm = newdate.getMonth() + 1;
    var y = newdate.getFullYear();

    var someFormattedDate = mm + '/' + dd + '/' + y;

    // --- test ---
    console.log(someFormattedDate);

    // set the timer
    // Set the date we're counting down to

    var countDownDate = new Date("Jan 5, 2019 15:37:25").getTime(); // pass the deadline as a string here (someFormattedDate)

    // Update the count down every 1 second
    var x = setInterval(function() {

      // Get todays date and time
      var now = new Date().getTime();

      // Find the distance between now and the count down date
      var distance = countDownDate - now;

      // Time calculations for days, hours, minutes and seconds
      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      // Display the result in the element with id="demo"
      document.getElementById("timerFrontPageRBT").innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
      //document.write (days + "d " + hours + "h " + minutes + "m " + seconds + "s ");

      // If the count down is finished, write some text
      if (distance < 0) {
        clearInterval(x);
        document.getElementById("timerFrontPageRBT").innerHTML = "Time is up!";
        //document.write("Time's up !!!");
      }
    }, 1000);
  // } else {
  //   // --- test ---
  //   console.log("No users found!");
  //
  // }

} else {
  // --- test ---
  console.log("No timers on this page!");

}






 //document.write (stud_ids);

  // var submissions = new XMLHttpRequest();
  // submissions.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/quizzes/830697/submissions', true);
  // submissions.setRequestHeader("Authorization", "Bearer 1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj")
  //
  // students.onload = function () {
  //   document.write (this.response);
  // }
  // if (students.status >= 200 && students.status < 400) {
  //   console.log(stud_ids);
  //   document.write (stud_ids);
  // } else {
  //   console.log('error');
  // }
//}
