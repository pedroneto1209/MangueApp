from flask import Flask

def create_app(config_filename):
    #Inicia o flask
    app = Flask(__name__)
    #Configura a partir do config
    app.config.from_object(config_filename)
    
    from app import api_bp
    #inicia o blueprint definido anteriormente
    app.register_blueprint(api_bp, url_prefix='/api')

    from models import db
    #inicia o banco de dados
    db.init_app(app)

    return app


if __name__ == "__main__":
    app = create_app("config")
    app.run(debug=True)