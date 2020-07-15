from flask import Blueprint
from flask_restful import Api
from resources.Register import Register
from resources.Signin import Signin
from resources.Graph import Graphs

#Cria uma modulação para ser utilizada depois
api_bp = Blueprint('api', __name__)
#ponto de entrada da api (inicia o host)
api = Api(api_bp)
#Route
api.add_resource(Register, '/register')
api.add_resource(Signin, '/signin')
api.add_resource(Graphs, '/graphs')