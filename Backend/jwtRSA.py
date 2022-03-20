from flask import Flask, request, jsonify, make_response
from datetime import datetime, timedelta, timezone
from connection import connect_mongodb
from functools import wraps
import jwt




db = connect_mongodb()
private_key = open('RSA/rs256.pem').read()
public_key = open('RSA/rs256.pub').read()


# decorador para verificar o JWT
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        # JWT passado no header request
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
            
        if not token:
            return {'message' : 'Token ausente!'}, 401
  
        try:
            data = jwt.decode(token, public_key, algorithms=['RS256'])            
        except Exception as e:
            #print("ERRO: ", e)
            return {'message' : 'Token inválido!'}, 401
        # retorna o contexto atual do usuário logado para a rota
        return  f(data, *args, **kwargs)
  
    return decorated


def create_token(user):

    token = jwt.encode({'encode':user, 'exp': (datetime.now(tz=timezone.utc) + timedelta(hours=24)),
            'nbf': datetime.now(tz=timezone.utc)}, private_key, algorithm='RS256')

    return token

