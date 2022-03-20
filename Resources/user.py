from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from werkzeug.security import safe_str_cmp
from Models.user import UserModel
from base64 import b64decode
from hashlib import sha256
import json
import jwt




atributos = reqparse.RequestParser()
atributos.add_argument('user', type=str, required=True, help="O campo usuário não pode estar em branco.")
atributos.add_argument('pw', type=str, required=True, help="O campo senha não pode estar em branco.")
        

class User(Resource):  
    # /user/{user}
    @token_required
    def get(self, data, user):
        
        user = UserModel.find_user(user)
        
        if user:
            
            return user
        return {'message':'Usuário não encontrado.'}, 404 # Not found
    


class UserRegister(Resource):
    # /register
    def post(self):
        
        dados = atributos.parse_args()

        if UserModel.find_by_login(dados['user']):
            return {"message": "O usuário '{}' já existe.".format(dados['user'])}
        print("Novo Usuário: ", dados)
        user = UserModel(dados['user'], dados['pw'])
        new_user = user.save_user()
        
        return {"messege": "O usuário '{}' foi cadastrado com sucesso!".format(new_user["user"])}, 201


class UserLogin(Resource):
    @classmethod
    def post(cls):

        dados = atributos.parse_args()
        user = UserModel.find_by_login(dados['user'])
        
        if user and safe_str_cmp(user["pwhash"], sha256(dados['pw'].encode('utf-8')).hexdigest()):

            private_key = open('RSA/rs256.pem').read()
            user.pop("_id")         
            token = create_token(user)

            return {'access_token': token}, 200
        return {'message':'Usuário ou senha inválido.'}, 401

'''
class UserDelete(Resource):  
    # /delete/{user}
    @token_required
    def delete(self, user):
        user = UserModel.find_user(user)
        if user:
            user.delete_user()
            return {'message':'Usuário deletado.'}

        return {'message':'Usuário não encontrado.'}, 404
'''

'''
class UserLogout(Resource):

    def post(self):
        jwt_id = get_jwt()['jti']   # Identificador do Token JWT
        print("JWT ID: ", jwt_id)
        BLACKLIST.add(jwt_id)   # Inserir essa Blacklist no MongoDB
        return {'message':'Logout realizado com sucesso!'}, 200
'''