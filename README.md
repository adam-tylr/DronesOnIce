# Drones On Ice
Project for Information Security at Ohio State... not real unfortunately :(

This project contains the source for the iOS app and back end

## iOS App
To get started with the iOS app, open the .xcworkspace file in the mobile project folder

## Server
python run.py in the server/flask folder (requires flask flask-restful flask-sqlalchemly flask-httpauth flask-marshmallow passlib flask-WTF)

##Endpoints
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
GET /user  (Requires Token)
```
Response
```
{
  "first_name": "Adam",
  "last_name": "Tyler"
}
```
###Place Order
Request
```
POST /order (Requires Token)

{
"flavor": "vanilla",
"total": "8",
"location": "my house"
}
```
Response:
```
{
  "status": "Order Received",
  "order_number": 4
}
```
###Get Order Info
Request
```
Get /order (Requires Token)
```
Response:
```
{
  "order_number": 4,
  "status": "Order Received",
  "time": "2016-09-29T21:19:52.749827",
  "total": 8,
  "flavor": "vanilla",
  "location": "my house"
}
```
##Internal Website
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
###Login
```
http://server.com/internal/login
```
###Dashboard
```
http://server.com/internal/orderstream
```
