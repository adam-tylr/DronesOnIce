import os
from flask import Flask
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPBasicAuth

app = Flask(__name__)
api = Api(app)
app.config.from_object('config')
db = SQLAlchemy(app)
auth = HTTPBasicAuth()
from app import models
if not os.path.exists('db.sqlite'):
    db.create_all()
from app import controllers
from app import routes
