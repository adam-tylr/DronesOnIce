from app import api

from controllers import HelloWorld

api.add_resource(HelloWorld, '/')
