from flask import request, jsonify, json
from flask_restful import Resource
from app.validator import UserSchema
from app.models import User
from app import db

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

class Register(Resource):
    def post(self):
        json_data = request.get_json()
        data, errors = UserSchema().load(json_data)
        if (errors):
            return errors, 400
        if (User.query.filter_by(username=data['username']).first() is not None):
            return {'error': 'Email address in use'}, 200
        user = User(username=data['username'], first_name=data['first_name'],
                last_name=data['last_name']);
        user.hash_password(data['password'])
        db.session.add(user)
        db.session.commit()
        return {'username': user.username}
