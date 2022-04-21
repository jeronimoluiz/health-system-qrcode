from hashlib import sha256
import secrets
from connection import connect_mongodb



db = connect_mongodb()

class UserModel:
    def __init__(self, user_id, pw, userType='pacient'):
        
        self.user = user_id
        self.pw = pw
        self.userType = userType


    @classmethod
    def find_user(cls, user_id):
        
        user_found = db.users.find_one({"user": user_id})
        #print(user_found)

        if user_found:
            user_found.pop("_id")
            user_found.pop("pwhash")
            
            return user_found
        else:
            #print("Usuário não encontrado")
            return {"message": "Usuário não encontrado"}, 400

    @classmethod
    def find_by_login(cls, user):
        
        user_found = db.users.find_one({"user": user})
        #print("Usuário encontrado: ", user_found)
        if user_found:
            return user_found
        else:
            #print("Usuário não encontrado")
            return None

    @classmethod
    def update_user(cls, user, data):
        update_status = db.users.update_one({"user": user}, {"$set":data})
        print("DADOS NOVOS: ", data)
    
        print("UPDATE: ", update_status)
        
        
    def save_user(self):
        
        #print("Counteúdo de self: ", self)

        new_user = db.users.insert_one({"user":self.user, "userType":self.userType, "pwhash":sha256(self.pw.encode('utf-8')).hexdigest()})
        #print("Novo usuário: ", new_user)
        if new_user:
            return {"user":self.user, "userType":self.userType}
        else:
            #print("Não foi possível criar usuário.")
            return {"message":"Não foi possível criar usuário"}
