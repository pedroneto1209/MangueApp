from flask import Blueprint
from flask_restful import Api
from resources.Register import Register

#Cria uma modulação para ser utilizada depois
api_bp = Blueprint('api', __name__)
#ponto de entrada da api (inicia o host)
api = Api(api_bp)
#Route
api.add_resource(Register, '/register')