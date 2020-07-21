from flask_restful import Resource
from flask import request
from models import db, User, Graph
import random
import string

class Graphs(Resource):

    def post(self):
        result = []
        header = request.headers["Authorization"]
        json_data = request.get_json(force=True)

        if not header:
            return {'Message': 'No API key'}, 400
        else:
            user = User.query.filter_by(apiKey=header).first()
            if user:
                graph = Graph(
                    userId = user.id,
                    data = json_data['data'],
                    typedata = json_data['typedata'],
                    date = json_data['date'],
                )
                db.session.add(graph)
                db.session.commit()

                result = Graph.serialize(graph)

                return { 'status': 'success', 'data': result }, 201
            else:
                return { 'Message': 'No user with that API key'}, 400


    def get(self):
        result = []
        header = request.headers["Authorization"]

        if not header:
            return {'Message': 'No API key'}, 400
        else:
            user = User.query.filter_by(apiKey=header).first()
            if user:
                graphs = Graph.query.filter_by(userId = user.id).all()
                for i in graphs:
                    result.append(Graph.serialize(i))

            return { 'status': 'success', 'data': result }, 201