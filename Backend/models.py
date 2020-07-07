from flask import Flask
#from marshmallow import Schema, fields, pre_load, validate
#rom flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy


#ma = Marshmallow()
#inicializa o alchemy para formatar o banco de dados
db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer(), primary_key=True)
    username = db.Column(db.String(), unique=True)
    first_name = db.Column(db.String())
    last_name = db.Column(db.String())
    password = db.Column(db.String())
    email = db.Column(db.String())
    api_key = db.Column(db.String())

    def __init__(self, api_key, username, first_name, last_name, password, email):
        self.api_key = api_key
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.password = password
        self.email = email

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'id' : self.id,
            'email' : self.email,
            'username' : self.username,
            'password' : self.password,
            'first_name' : self.first_name,
            'last_name' : self.last_name,
            'api_key' : self.api_key
        }