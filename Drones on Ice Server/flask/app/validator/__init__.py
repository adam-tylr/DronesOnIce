from marshmallow import Schema, fields, validate

class UserSchema(Schema):
    username = fields.Email(required=True, validate=validate.Length(max=100))
    password = fields.Str(required=True, validate=validate.Length(min=8, max=30))
    first_name = fields.Str(required=True, validate=validate.Length(max=30))
    last_name = fields.Str(required=True, validate=validate.Length(max=30))

class LoginSchema(Schema):
    username = fields.Email(required=True, validate=validate.Length(max=100))
    password = fields.Str(required=True, validate=validate.Length(min=8, max=30))

class OrderSchema(Schema):
    location = fields.Str(required=True, validate=validate.Length(max=100))
    flavor = fields.Str(required=True, validate=validate.Length(max=50))
    total = fields.Int()
