#from typing_extensions import Required
from flask_restful import Resource, reqparse
#from flask_jwt_extended import create_access_token, jwt_required, get_jwt
from werkzeug.security import safe_str_cmp
from Models.user import UserModel
from hashlib import sha256
from base64 import b64decode
from blacklist import BLACKLIST
import json


# ambPath = ""
# error = Check_error(pathModel+'errors/erros.json')

atributos = reqparse.RequestParser()
atributos.add_argument('user', type=str, required=True, help="O campo usuário não pode estar em branco.")
atributos.add_argument('pw', type=str, required=True, help="O campo senha não pode estar em branco.")
        

class User(Resource):  
    # /user/{user_id}
    
    #@jwt_required
    def get(self, user):
        user = UserModel.find_user(user)
        if user:
            return user.json()
        return {'message':'Usuário não encontrado.'}, 404 # Not found
    
    #@jwt_required
    def delete(self, user):
        user = UserModel.find_user(user)
        if user:
            user.delete_user()
            return {'message':'Usuário deletado.'}

        return {'message':'Usuário não encontrado.'}, 404


class UserRegister(Resource):
    # /register
    def post(self):
        
        dados = atributos.parse_args()

        if UserModel.find_by_login(dados['user']):
            return {"message":"O usuário '{}' já existe.".format(dados['user'])}
        print("Novo Usuário: ", dados)
        user = UserModel(dados['user'], dados['pw'])
        new_user = user.save_user()
        
        return new_user, 201


class UserLogin(Resource):
    @classmethod
    def post(cls):

        dados = atributos.parse_args()
        user = UserModel.find_by_login(dados['user'])
        
        if user and safe_str_cmp(user["pwhash"], sha256(dados['pw'].encode('utf-8')).hexdigest()):
            token_de_acesso = create_access_token(identity=user["user"])
            return {'access_token': token_de_acesso}, 200
        return {'message':'Usuário ou senha inválido.'}, 401

class UserLogout(Resource):
    #@jwt_required()
    def post(self):
        jwt_id = get_jwt()['jti']   # Identificador do Token JWT
        print("JWT ID: ", jwt_id)
        BLACKLIST.add(jwt_id)   # Inserir essa Blacklist no MongoDB
        return {'message':'Logout realizado com sucesso!'}, 200
