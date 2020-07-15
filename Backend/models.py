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

class Graph(db.Model):
    __tablename__ = 'graphs'

    id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column(db.Integer(), db.ForeignKey('users.id'))
    data = db.Column(db.String())
    typedata = db.Column(db.String())
    date = db.Column(db.String())

    def __init__(self, user_id, data, typedata, date):
        self.user_id = user_id
        self.data = data
        self.typedata = typedata
        self.date = date

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'user_id' : self.user_id,
            'id' : self.id,
            'data' : self.data,
            'typedata' : self.typedata,
            'date' : self.date
        }