from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from Models.prescription import PrescriptionModel
from Models.user import UserModel
import hashlib
import qrcode
from io import BytesIO
import base64
from datetime import datetime
import pytz


atributos = reqparse.RequestParser()
atributos.add_argument('patient_id', type=str, required=False, help="O campo patient_id não pode estar em branco.")
atributos.add_argument('medicine_id', type=str, required=False, help="O campo medicine_id não pode estar em branco.")
atributos.add_argument('application_time', type=str, required=False, help="O campo application_time não pode estar em branco.")
atributos.add_argument('description', type=str, required=False, help="O campo description não pode estar em branco.")



class PrescriptionRegister(Resource):
    # /prescription-register
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)

        print("TOKEN: ", self)

        token_user = UserModel.find_by_login(self.get("encode").get("user"))

        if token_user.get("userType") == "doctor":
            doctor = token_user.get("user")
        else:
            return {"message": "O usuário não possui permissão para prescrever medicamentos."}, 400


        prescription_found = PrescriptionModel.find_prescription(dados['patient_id'], dados['medicine_id'])

        if prescription_found:
            
            final_day = datetime.strptime(str(datetime.now(pytz.timezone('America/Sao_Paulo')).strftime('%Y-%m-%d')), '%Y-%m-%d')
            for presc in prescription_found:
                initial_day = datetime.strptime(presc.get("prescriptionDate"), '%Y-%m-%d')
                
                quantidade_dias = abs((final_day - initial_day).days)
                print("Quantidade de dias: ", quantidade_dias)

                if quantidade_dias <= 10:
                    return {"message": "O medicamento já foi prescrito para este paciente nos últimos 10 dias."}, 400
        print("Nova prescrição: ", dados)


        

        prescription_time = str(datetime.now(pytz.timezone('America/Sao_Paulo')).strftime('%Y-%m-%d'))

        hashText = hashlib.md5(str(dados.get('patient_id') + dados.get('medicine_id') + str(prescription_time)).encode("utf-8")).hexdigest()

        imagem = qrcode.make(hashText)

        buffer = BytesIO()
        imagem.save(buffer, format = "PNG")

        img_str = str(base64.b64encode(buffer.getvalue()), 'utf-8')

        prescription = PrescriptionModel(dados.get('patient_id'), doctor, dados.get('medicine_id'), dados.get('description'), dados.get('application_time'), prescription_time, img_str, hashText)
        new_prescription = prescription.save_prescription()
        
        
        return new_prescription


class PrescriptionUpdate(Resource):
    # /prescription-update
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)

        token_user = UserModel.find_by_login(self.get("encode").get("user"))

        if token_user.get("userType") == "doctor":
            doctor = token_user.get("user")
        else:
            return {"message": "O usuário não possui permissão para atualizar a prescrição médica."}, 400

 
        prescription = PrescriptionModel(dados.get('patient_id'), doctor, dados.get('medicine_id'), dados.get('application_time'))
        new_prescription = prescription.update_prescription()
        
        
        return new_prescription


class PrescriptionUser(Resource):
    # /prescription/{user}
    @token_required
    def get(self, data, user):
        print("DATA: ", self)
        print("Usuário ID: ", user)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        prescription = None

        if user_found["userType"] == "doctor" or user_found["user"] == user:

            prescription = PrescriptionModel.find_prescription(user)
           
        print("PRESCRIPTION: ", prescription)
        if prescription:
            #prescription.pop("QRCode")
            #prescription.pop("hashText")

            return prescription, 200
        
        return {"message": "Não foi encontrado nenhuma prescrição para este paciente."}, 400


class Prescription(Resource):
    # /prescription/{user}/{medicine_id}
    @token_required
    def get(self, data, user, medicine_id):
        print("DATA: ", self)
        print("Usuário ID: ", user)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        prescription = None

        if user_found["userType"] == "doctor" or user_found["user"] == user:

            prescription = PrescriptionModel.find_prescription(user, medicine_id)
           
        
        if prescription:

            return prescription, 200
        
        return {"message": "Não foi encontrado nenhuma prescrição para este paciente."}, 400

class PrescriptionPDF(Resource):
    # /prescription-pdf/{user}/{medicine_id}
    @token_required
    def get(self, data, user, medicine_id):
        print("DATA: ", self)
        print("Usuário ID: ", user)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        prescription = None

        if user_found["userType"] == "doctor" or user_found["user"] == user:

            prescription = PrescriptionModel.find_prescription(user, medicine_id)
           
        
        if prescription:

            pdf = prescription.get("prescriptionPDF")

            return {"prescriptionPDF": str(pdf)}, 200
        
        return {"message": "Não foi encontrado nenhuma prescrição para este paciente."}, 400


class PrescriptionQRCode(Resource):
    # /prescription-qrcode/{user}/{medicine_id}
    @token_required
    def get(self, data, user, medicine_id):
        print("DATA: ", self)
        print("Paciente ID: ", user)
        print("Medicine ID: ", medicine_id)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        prescription = None

        if user_found["userType"] == "doctor" or user_found["userType"] == "secretary" or user_found["user"] == user:

            prescription = PrescriptionModel.find_prescription(user, medicine_id)
            prescription = prescription.pop("QRCode")
           
        
        if prescription:

            return {"QRCode": prescription}, 200
        
        return {"message": "Seu usuário não possui acesso às prescrições."}, 400

