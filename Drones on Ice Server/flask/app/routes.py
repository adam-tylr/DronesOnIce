from app import api
from app.controllers import HelloWorld
from app.controllers import Register
from app.controllers import Login
from app.controllers import User

api.add_resource(HelloWorld, '/')
api.add_resource(Register, '/user/register')
api.add_resource(Login, '/user/login')
api.add_resource(User, '/user')
