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
    firstname = db.Column(db.String())
    lastname = db.Column(db.String())
    password = db.Column(db.String())
    email = db.Column(db.String())
    apiKey = db.Column(db.String())

    def __init__(self, apiKey, username, firstname, lastname, password, email):
        self.apiKey = apiKey
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
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
            'firstname' : self.firstname,
            'lastname' : self.lastname,
            'apiKey' : self.apiKey
        }

class Graph(db.Model):
    __tablename__ = 'graphs'

    id = db.Column(db.Integer(), primary_key=True)
    userId = db.Column(db.Integer(), db.ForeignKey('users.id'))
    data = db.Column(db.String())
    typedata = db.Column(db.String())
    date = db.Column(db.String())

    def __init__(self, userId, data, typedata, date):
        self.userId = userId
        self.data = data
        self.typedata = typedata
        self.date = date

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'userId' : self.userId,
            'id' : self.id,
            'data' : self.data,
            'typedata' : self.typedata,
            'date' : self.date
        }