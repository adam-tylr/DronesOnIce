from flask import request, jsonify, json, g
from flask_restful import Resource
from app.validator import UserSchema
from app.validator import LoginSchema
from app.models import User
from app import db, auth

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


class Login(Resource):
    def post(self):
        json_data = request.get_json()
        data, errors = LoginSchema().load(json_data)
        if (errors):
            return errors, 400
        user = User.query.filter_by(username=data['username']).first()
        if (user is None or not user.verify_password(data['password'])):
            return {'error': 'Email or password is invalid'}
        token = user.generate_auth_token()
        return { 'token': token.decode('ascii') }


class User(Resource):
    @auth.login_required
    def get(self):
        return {'first_name': g.user.first_name, 'last_name': g.user.last_name}
        
