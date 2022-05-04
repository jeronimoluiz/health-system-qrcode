from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from Models.medicine import MedicineModel
from Models.user import UserModel
import hashlib
import qrcode
from io import BytesIO
import base64


atributos = reqparse.RequestParser()
atributos.add_argument('medicine_id', type=str, required=True, help="O campo medicine_id não pode estar em branco.")
atributos.add_argument('medicine_name', type=str, required=False, help="O campo medicine_name não pode estar em branco.")
atributos.add_argument('manufacturer', type=str, required=False, help="O campo manufacturer não pode estar em branco.")
atributos.add_argument('expiration', type=str, required=False, help="O campo expiration não pode estar em branco.")
atributos.add_argument('inventory', type=str, required=False, help="O campo inventory não pode estar em branco.")



class MedicineRegister(Resource):
    # /medicine-register
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)


        if MedicineModel.find_medicine(dados.get("medicine_id")):
            return {"message": "O medicamento já foi cadastrado anteriormente."}, 400
        print("Nova Info emergência: ", dados)

        hashText = hashlib.md5(str(dados.get('medicine_id')).encode("utf-8")).hexdigest()

        print("HASH: ", hashText)

        imagem = qrcode.make(hashText)

        buffer = BytesIO()
        imagem.save(buffer, format = "PNG")

        img_str = str(base64.b64encode(buffer.getvalue()), 'utf-8')

        medicine = MedicineModel(dados.get('medicine_id'), dados.get('medicine_name'), dados.get('manufacturer'), dados.get('expiration'), dados.get('inventory'), img_str, hashText)
        new_medicine = medicine.save_medicine()
        
        
        return new_medicine


class MedicineUpdate(Resource):
    # /medicine-update
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)


        if not MedicineModel.find_medicine(dados.get("medicine_id")):
            return {"message": "O medicamento informado não pode ser atualizado, pois o mesmo não foi encontrado."}, 400
        
        print("Atualização Info emergência: ", dados)


        medicine = MedicineModel(dados.get('medicine_id'), dados.get('medicine_name'), dados.get('manufacturer'), dados.get('expiration'), dados.get('inventory'))
        new_medicine = medicine.update_medicine()
        
        
        return new_medicine



class Medicine(Resource):
    # /medicine/{medicine_id}
    @token_required
    def get(self, data, medicine_id):
        print("DATA: ", self)
        print("Medicine ID: ", medicine_id)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        medicine = None

        if user_found["userType"] == "doctor" or user_found["userType"] == "rescuer":

            medicine = MedicineModel.find_medicine(medicine_id)
           
        
        if medicine:
            medicine.pop("QRCode")
            medicine.pop("hashText")

            return medicine, 200
        
        return {"message": "Seu usuário não possui acesso a base de dados de medicamentos."}, 400


class MedicineList(Resource):
    # /medicine-list
    def get(self):

        medicine = MedicineModel.list_medicine()

        if medicine:
            return medicine, 200
        
        return {"message": "Não foi possível listar os medicamentos."}, 400

class MedicineListName(Resource):
    # /medicine-list-name
    def get(self):

        medicine = MedicineModel.list_medicine_name()

        if medicine:
            return medicine, 200
        
        return {"message": "Não foi possível listar os nomes e IDs dos medicamentos."}, 400


class MedicineQRCode(Resource):
    # /medicine-qrcode/{medicine_id}
    @token_required
    def get(self, data, medicine_id):
        print("DATA: ", self)
        print("Medicine ID: ", medicine_id)
        print(self.get("encode").get("user"))
        user_found =  UserModel.find_by_login(self.get("encode").get("user"))
        print(user_found)

        medicine = None

        if user_found["userType"] == "doctor" or user_found["userType"] == "secretary":

            medicine = MedicineModel.find_medicine(medicine_id)
            medicine = medicine.pop("QRCode")
           
        
        if medicine:

            return {"QRCode": medicine}, 200
        
        return {"message": "Seu usuário não possui acesso a base de dados de medicamentos."}, 400

