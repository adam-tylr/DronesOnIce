from flask import request, jsonify, json, g, render_template, make_response, flash, redirect, session
from flask_restful import Resource
from sqlalchemy import desc
from app.validator import UserSchema
from app.validator import LoginSchema
from app.validator import OrderSchema
from app import db, auth
from app.models import User, Order
from datetime import datetime
from app.forms import LoginForm

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}


class Register(Resource):
    def post(self):
        json_data = request.get_json()
        data, errors = UserSchema().load(json_data)
        if (errors):
        	msg = ""
        	for error in errors:
        		msg = msg + error + ": " +errors[error][0] + " "
        	return {"error": msg}, 400
        if (User.query.filter_by(username=data['username']).first() is not None):
            return {'error': 'Email address in use'}, 200
        user = User(username=data['username'], first_name=data['first_name'],
                last_name=data['last_name'], access=0);
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
        	msg = ""
        	for error in errors:
        		msg = msg + error + ": " +errors[error][0] + " "
        	return {"error": msg}, 400
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
        	msg = ""
        	for error in errors:
        		msg = msg + error + ": " +errors[error][0] + " "
        	return {"error": msg}, 400
        order = Order(timestamp=datetime.utcnow(), user=g.user, location=data['location'], flavor=data['flavor'],total=data['total'], status="Order Received")
        db.session.add(order)
        db.session.commit()
        return {'order_number': order.id, 'status': order.status}

    @auth.login_required
    def get(self):
        order = Order.query.filter_by(user_id = g.user.id).order_by(desc(Order.timestamp)).first()
        return {'order_number': order.id, 'time': order.timestamp.isoformat(), 'location': order.location,
        	 'flavor': order.flavor, 'total': order.total, 'status':order.status}
        	 

class InternalUser(Resource):

	def post(self):
		json_data = request.get_json()
		data, errors = UserSchema().load(json_data)
		if (errors):
			return errors, 400
		if (User.query.filter_by(username=data['username']).first() is not None):
			return {'error': 'Email address in use'}, 200
		user = User(username=data['username'], first_name=data['first_name'], last_name=data['last_name'], access=1)
		user.hash_password(data['password'])
		db.session.add(user)
		db.session.commit()
		token = user.generate_auth_token()
		return "User Registered"

		
class InternalLogin(Resource):
	
	def post(self):
		form = LoginForm()
		if form.validate_on_submit():
			user = User.query.filter_by(username=form.email.data).first()
			if (user is None or not user.verify_password(form.password.data) or user.access == 0):
				flash("Invalid Login")
				return redirect("/internal/login")
			else:
				session['user'] = user.id
				return redirect("/internal/orderstream")
		headers = {'Content-Type': 'text/html'}
		
		
	def get(self):
		form = LoginForm()
		headers = {'Content-Type': 'text/html'}
		return make_response(render_template("login.html", form=form),200,headers)


class InternalLogout(Resource):

	def get(self):
		session.pop('user', None)
		flash("You have been logged out")  
		return redirect("/internal/login")


class InternalDashboard(Resource):

	def get(self):
		if not 'user' in session:
			flash("You must be logged in to access this page")
			return redirect("/internal/login")
		user = User.query.get(session['user'])
		name = user.first_name + ' ' + user.last_name
		open_orders = Order.query.filter_by(status = "Order Received").order_by(Order.timestamp)
		cancelled_orders = Order.query.filter_by(status = "Cancelled").order_by(Order.timestamp)
		shipped_orders = Order.query.filter_by(status = "Shipped").order_by(Order.timestamp)
		headers = {'Content-Type': 'text/html'}
		return make_response(render_template("orderstream.html", user_name=name, open_orders=open_orders,
				cancelled_orders=cancelled_orders, shipped_orders=shipped_orders, access=user.access),200,headers)
		

class InternalShipOrder(Resource):
	
	def get(self):
		if not 'user' in session:
			flash("You must be logged in to access this page")
			return redirect("/internal/login")
		orderNum = request.args["order"]
		order = Order.query.get(orderNum)
		order.status = "Shipped"
		db.session.add(order)
		db.session.commit()
		return redirect("/internal/orderstream")
		

class InternalCancelOrder(Resource):
	
	def get(self):
		if not 'user' in session:
			flash("You must be logged in to access this page")
			return redirect("/internal/login")
		orderNum = request.args["order"]
		order = Order.query.get(orderNum)
		order.status = "Cancelled"
		db.session.add(order)
		db.session.commit()
		return redirect("/internal/orderstream")
        
