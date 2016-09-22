# Drones On Ice
This project contains the source for the iOS app and back end

## iOS App
To get started with the iOS app, open the .xcworkspace file in the mobile project folder

## Server
python run.py in the server/flask folder (requires flask flask-restful flask-sqlalchemly flask-httpauth flask-marshmallow passlib)

###Routes

``` http
POST /user/register

{   'username': 'tyler.147@osu.edu',
    'password': 'Pa$$wd',
    'first_name': 'Adam',
    'last_name': 'Tyler'
}
```
