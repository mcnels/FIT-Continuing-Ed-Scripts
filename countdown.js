// Create a request variable and assign a new XMLHttpRequest object to it.
//var students = new XMLHttpRequest();
//var findID = new XMLHttpRequest();

$.get('/api/v1/users/self/profile', function(profile) {
    console.log(profile.login_id);
});
/*findID.open('GET', 'https://fit.instructure.com/api/v1/users/self/profile', true);
findID.setRequestHeader("Authorization", "Bearer 1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj");
// Send request
findID.send();
findID.onload = function () {
  console.log(this.response);
}*/
// Open a new connection, using the GET request on the URL endpoint
//students.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/students', true);
//students.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/quizzes/830697/submissions', true);
// Add authorization
//students.setRequestHeader("Authorization", "Bearer 1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj");
// Send request
//students.send();

// Do this with response...
// students.onload = function () {
//   var data = JSON.parse(this.response);
//   // console.log(data.quiz_submissions);
//   var stud_ids = [];
//   var i;
//   // save ids from response in an array
//   //for (i = 0; i < data.length; i++) {
//     stud_ids.push(data.quiz_submissions[0].finished_at);
//   //}
//   console.log(stud_ids);
// document.write(stud_ids);
//   // find deadline
//   var tt = stud_ids; // formatted as mm/dd/yyyy

//     var date = new Date(tt); // submdate
//     var newdate = new Date(date); //deadline

//     newdate.setDate(newdate.getDate() + 180);

//     var dd = newdate.getDate();
//     var mm = newdate.getMonth() + 1;
//     var y = newdate.getFullYear();

//     var someFormattedDate = mm + '/' + dd + '/' + y;
//     //display here
//     document.getElementById('follow_Date').value = someFormattedDate;

//   //
//   //
//   //   // set the timer
//   // Set the date we're counting down to

//   var countDownDate = new Date("Jan 5, 2019 15:37:25").getTime(); // pass the deadline as a string here

//   // Update the count down every 1 second
//   var x = setInterval(function() {

//     // Get todays date and time
//     var now = new Date().getTime();

//     // Find the distance between now and the count down date
//     var distance = countDownDate - now;

//     // Time calculations for days, hours, minutes and seconds
//     var days = Math.floor(distance / (1000 * 60 * 60 * 24));
//     var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
//     var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
//     var seconds = Math.floor((distance % (1000 * 60)) / 1000);

//     // Display the result in the element with id="demo"
//     //document.getElementById("demo").innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
//     document.write (days + "d " + hours + "h " + minutes + "m " + seconds + "s ");

//     // If the count down is finished, write some text
//     if (distance < 0) {
//       clearInterval(x);
//       //document.getElementById("demo").innerHTML = "EXPIRED";
//       document.write("Time's up !!!");
//     }
//   }, 1000);
//  document.write (stud_ids);

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
