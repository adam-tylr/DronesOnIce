from flask import request, jsonify, json, g
from flask_restful import Resource
from sqlalchemy import desc
from app.validator import UserSchema
from app.validator import LoginSchema
from app.validator import OrderSchema
from app import db, auth
from app.models import User, Order
from datetime import datetime

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
        token = user.generate_auth_token()
        return { 'token': token.decode('ascii') }


class Login(Resource):
    def post(self):
        json_data = request.get_json()
        print(json_data)
        data, errors = LoginSchema().load(json_data)
        if (errors):
            return errors, 400
        user = User.query.filter_by(username=data['username']).first()
        if (user is None or not user.verify_password(data['password'])):
            return {'error': 'Email or password is invalid'}
        token = user.generate_auth_token()
        return { 'token': token.decode('ascii') }


class UserInfo(Resource):
    @auth.login_required
    def get(self):
        return {'first_name': g.user.first_name, 'last_name': g.user.last_name}

class Orders(Resource):
    @auth.login_required
    def post(self):
        json_data = request.get_json()
        data, errors = OrderSchema().load(json_data)
        if (errors):
            return errors, 400
        order = Order(timestamp=datetime.utcnow(), user=g.user, location=data['location'], flavor=data['flavor'],total=data['total'], status="Order Received")
        db.session.add(order)
        db.session.commit()
        return {'order_number': order.id, 'status': order.status}

    @auth.login_required
    def get(self):
        order = Order.query.filter_by(user_id = g.user.id).order_by(desc(Order.timestamp)).first()
        return {'order_number': order.id, 'time': order.timestamp.isoformat(), 'location': order.location,
        	 'flavor': order.flavor, 'total': order.total, 'status':order.status}
        
