# Drones On Ice
This project contains the source for the iOS app and back end

## iOS App
To get started with the iOS app, open the .xcworkspace file in the mobile project folder

## Server
python run.py in the server/flask folder (requires flask flask-restful flask-sqlalchemly flask-httpauth flask-marshmallow passlib)

##Routes
###Register a User
Request
```
POST /user/register

{   'username': 'tyler.147@osu.edu',
    'password': 'Pa$$wd',
    'first_name': 'Adam',
    'last_name': 'Tyler'
}
```
Response:
```
{
  "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ3NDU4ODgzOCwiaWF0IjoxNDc0NTg1NjM4fQ.eyJpZCI6MX0.yjwXkbXxl_fncKodjzbEeQm194j8F_3qon_avIfidec"
}
```
---
###Authenticate User
Request
```
POST /user/login

{   'username': 'tyler.147@osu.edu',
    'password': 'Pa$$wd',
}
```
Response:
```
{
  "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ3NDU4ODgzOCwiaWF0IjoxNDc0NTg1NjM4fQ.eyJpZCI6MX0.yjwXkbXxl_fncKodjzbEeQm194j8F_3qon_avIfidec"
}
```
---
###Get User Info
Request:
```
GET /user
```
Response
```
{
  "first_name": "Adam",
  "last_name": "Tyler"
}
```
