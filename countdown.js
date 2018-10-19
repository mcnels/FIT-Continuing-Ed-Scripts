// Create a request variable and assign a new XMLHttpRequest object to it.
var request = new XMLHttpRequest();

// Open a new connection, using the GET request on the URL endpoint
request.open('GET', 'https://fit.instructure.com/api/v1/courses/533668/students', true);
request.setRequestHeader("Authorization", "Bearer 1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj");

request.onload = function () {
  // Begin accessing JSON data here
  var data = JSON.parse(this.response);
  if (request.status >= 200 && request.status < 400) {
    console.log(data);
    document.write (data);
  } else {
    console.log('error');
  }
}

// Send request
request.send();
