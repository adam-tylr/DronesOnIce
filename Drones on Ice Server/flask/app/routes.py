from app import api
from app.controllers import HelloWorld

api.add_resource(HelloWorld, '/')
