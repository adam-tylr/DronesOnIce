from app import api
from app.controllers import HelloWorld
from app.controllers import Register

api.add_resource(HelloWorld, '/')
api.add_resource(Register, '/user/register')
