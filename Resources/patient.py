from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from Models.patient import EmergencyInfoModel
from Models.user import UserModel
import hashlib
import qrcode
from io import BytesIO
import base64


atributos = reqparse.RequestParser()
atributos.add_argument('user', type=str, required=True, help="O campo usuário não pode estar em branco.")
atributos.add_argument('name', type=str, required=True, help="O campo name não pode estar em branco.")
atributos.add_argument('address', type=str, required=True, help="O campo address não pode estar em branco.")
atributos.add_argument('bloodType', type=str, required=True, help="O campo bloodType não pode estar em branco.")
atributos.add_argument('emergencyContact', type=str, required=True, help="O campo emergencyContact não pode estar em branco.")
atributos.add_argument('allergies', type=str, required=False)
atributos.add_argument('medicines', type=str, required=False)
atributos.add_argument('healthInfo', type=str, required=False)
atributos.add_argument('organDonor', type=str, required=False)



class EmergencyInfoRegister(Resource):
    # /emergency-info-register
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)

        hashText = hashlib.md5(str(dados).encode("utf-8")).hexdigest()

        print("HASH: ", hashText)

        
        if EmergencyInfoModel.find_emergency_info(dados['user']):
            return {"message": "As informações de emergência já foram cadastradas."}, 400
        print("Nova Info emergência: ", dados)
        emergency_info = EmergencyInfoModel(dados['user'], hashText, dados['address'], dados['name'], dados['bloodType'], dados['emergencyContact'], dados['allergies'], dados['medicines'], dados['healthInfo'], dados['organDonor'])
        new_emergency_info = emergency_info.save_emergency_info()
        
        
        return new_emergency_info


class EmergencyInfo(Resource):  
    # /emergency-info/{user}
    @token_required
    def get(self, data, user):
        print("DATA: ", self)
        print("USUÁRIO: ", user)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        emergency_info = None

        if user_found["user"] == user:
            user_found.pop("_id")
            user_found.pop("pwhash")
            emergency_info = EmergencyInfoModel.find_emergency_info(user)
        
        if emergency_info:

            return emergency_info, 200
        return {'message':'Usuário não encontrado.'}, 404 # Not found


class MakeEmergencyInfoQRCode(Resource):  
    # /make-emergency-info-qrcode/{code}
    #@token_required
    def get(self, user):
        print("DATA: ", self)
        print("CÓDIGO: ", user)
        
        emergency_info = EmergencyInfoModel.find_emergency_info(user)

            
        
        if emergency_info:

            hashText = emergency_info.pop("hashText")
            imagem = qrcode.make(hashText)

            buffer = BytesIO()
            imagem.save(buffer, format = "PNG")

            img_str = str(base64.b64encode(buffer.getvalue()), 'utf-8')


            return {"qrcode": img_str}, 200
        return {'message':'Não foi possível gerar QR Code.'}, 404 # Not found


class ReadEmergencyInfoQRCode(Resource):  
    # /emergency-info-qrcode-read/{hash}
    @token_required
    def get(self, data, hash):
        print("TOKEN: ", self)
        print("HASH: ", hash)

        token_user = UserModel.find_by_login(self.get("encode").get("user"))

        
        emergency_info = EmergencyInfoModel.find_emergency_info_qrcode(hash)
        pacient_user = UserModel.find_by_login(emergency_info["user"])

        permission_doctor = False
        permission_rescuer = False
        for doctor in pacient_user["medicalTeam"]:
            if doctor == token_user["user"]:
                permission_doctor = True

        if token_user["userType"] == "rescuer":
            permission_rescuer = True
        

        
        if emergency_info and permission_doctor:

            # Implementar registros médicos, exames e etc.
            print("É MÉDICO DO PACIENTE!")

            emergency_info.pop("_id")
            emergency_info.pop("user")
            
            return {"emergencyInfo": emergency_info}, 200
        elif emergency_info and permission_rescuer:
           
            print("SOCORRISTA!")

            emergency_info.pop("_id")
            emergency_info.pop("user")

            return {"emergencyInfo": emergency_info}, 200

        return {'message':'Nenhum registro foi encontrado.'}, 404 # Not found