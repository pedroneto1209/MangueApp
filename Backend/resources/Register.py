from flask_restful import Resource
from flask import request
from models import db, User

class Register(Resource):
    #qualquer GET request no route register vem parar nessa função
    def get(self):
        #lista o id de todos os usuarios
        users = User.query.all()
        #associa os usuarios a uma lista e retorna ela
        user_list = []
        for i in range(len(users)):
            user_list.append(users[i].serialize())
        return {'status' : str(user_list)}, 200 

    #qualquer POST request no route register vem parar nessa função
    def post(self):
        #checa se recebeu request
        json_data = request.get_json(force=True)
        if not json_data:
            return {'message': 'input não recebido'}, 400
        #checa se o username já não ta registrado
        user = User.query.filter_by(username=json_data['username']).first()
        if user:
            return {'message': 'nome de usuário já registrado'}, 400
        #checa se o email já não ta registrado
        user = User.query.filter_by(email=json_data['email']).first()
        if user:
            return {'message': 'email já registrado'}, 400

        #registra o novo usuário e retorna seus dados registrados
        user = User(
            first_name = json_data['first_name'],
            last_name = json_data['last_name'],
            email = json_data['email'],
            password = json_data['password'],
            username = json_data['username']
        )
        db.session.add(user)
        db.session.commit()

        result = User.serialize(user)

        return { 'status': 'success', 'data': result }, 201