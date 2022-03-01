from hashlib import sha256
import secrets
from connection import connect_mongodb


db = connect_mongodb()

class UserModel:
    def __init__(self, user_id, pw):
        
        self.user = user_id
        self.pw = pw


    @classmethod
    def find_user(cls, user_id, pwhash):
        
        user_found = db.users.find_one({"user": user_id})

        if user_found:
            user_val = user_found["user"]
            pw_check = user_found["pwhash"]

            if pwhash == pw_check:
                print("Tudo certo")
                #jwt_db = client.jwt_db
                return user_found
            else:
                print("Senha incorreta")
                return None
        else:
            print("Usuário não encontrado")
            return None

    @classmethod
    def find_by_login(cls, user):
        
        user_found = db.users.find_one({"user": user})
        print("Usuário encontrado: ", user_found)
        if user_found:
            return user_found
        else:
            print("Usuário não encontrado")
            return None

    
    def save_user(self):
        print("Counteúdo de self: ", self)

        key_homologacao = sha256((str(secrets.randbits(256)) + str(self.user) + "/homologacao").encode('utf-8')).hexdigest()
        key_producao = sha256((str(secrets.randbits(256)) + str(self.user) + "/producao").encode('utf-8')).hexdigest()

        new_user = db.users.insert_one({"user":self.user, "pwhash":sha256(self.pw.encode('utf-8')).hexdigest(), "ambientes":{key_homologacao:{"path":self.user+"/homologacao"}, key_producao:{"path":self.user+"/producao"}}})
        print("Novo usuário: ", new_user)
        if new_user:
            return {"user":self.user, "ambientes":{key_homologacao:{"path":self.user+"/homologacao"}, key_producao:{"path":self.user+"/producao"}}}
        else:
            print("Não foi possível criar usuário.")
            return {"message":"Não foi possível criar usuário"}