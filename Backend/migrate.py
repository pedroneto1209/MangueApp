from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
from models import db
from run import create_app


app = create_app('config')

migrate = Migrate(app, db)
manager = Manager(app)
manager.add_command('db', MigrateCommand)

#db init migra e cria uma pasta
#db migrate preenche a migração com as mudanças necessarias e gera a tabela com as colunas de modelos
#db upgrade repetir todas as vezes que os modelos mudarem

manager.run()