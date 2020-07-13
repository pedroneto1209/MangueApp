from flask_restful import Resource
from flask import request
from models import db, User
import random
import string

class Signin(Resource):
    #qualquer POST request no route register vem parar nessa função
    def post(self):
        #checa se recebeu request
        json_data = request.get_json(force=True)
        if not json_data:
            return {'message': 'input não recebido'}, 400
        #checa se o username já não ta registrado
        user = User.query.filter_by(username=json_data['username']).first()
        if not user:
            return {'message': 'nome de usuário não existe'}, 400

        if user.password != json_data['password']:
            return {'message': 'Senha incorreta'}, 400

        result = User.serialize(user)

        return { 'status': 'success', 'data': result }, 201

    def generate_key(self):
        return ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(50))