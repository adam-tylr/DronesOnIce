from app import api
from app.controllers import HelloWorld
from app.controllers import Register
from app.controllers import Login
from app.controllers import UserInfo
from app.controllers import Orders
from app.controllers import InternalUser
from app.controllers import InternalLogin
from app.controllers import InternalDashboard
from app.controllers import InternalLogout

# External endpoints
api.add_resource(HelloWorld, '/')
api.add_resource(Register, '/user/register')
api.add_resource(Login, '/user/login')
api.add_resource(UserInfo, '/user')
api.add_resource(Orders, '/order')

# Internal endpoints
api.add_resource(InternalUser, '/internal/user')
api.add_resource(InternalLogin, '/internal/login')
api.add_resource(InternalLogout, '/internal/logout')
api.add_resource(InternalDashboard, '/internal/orderstream')
