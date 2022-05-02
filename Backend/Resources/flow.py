from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from Models.medicine import MedicineModel
from Models.user import UserModel
from Models.procedures import ProcedureModel
from Models.prescription import PrescriptionModel
import hashlib
import qrcode
from io import BytesIO
import base64
from datetime import datetime
import pytz



atributos = reqparse.RequestParser()
atributos.add_argument('QRcode_patient', type=str, required=True, help="O campo QRcode_patient não pode estar em branco.")
atributos.add_argument('QRcode_employee', type=str, required=True, help="O campo QRcode_employee não pode estar em branco.")
atributos.add_argument('QRcode_medicine', type=str, required=True, help="O campo QRcode_medicine não pode estar em branco.")



class FlowQuery(Resource):
    # /flow-query
    @token_required
    def get(self, data, QRcode_patient, QRcode_employee, QRcode_medicine):

        print("QRCode paciente: ", QRcode_patient)
        print("QRCode funcionário: ", QRcode_employee)
        print("QRCode medicamento: ", QRcode_medicine)


        patient_qrcode = UserModel.find_user_by_qrcode(QRcode_patient)
        patient_employee = UserModel.find_user_by_qrcode(QRcode_employee)
        patient_medicine = MedicineModel.find_medicine_qrcode(QRcode_medicine)

        print("Paciente: ", patient_qrcode.get("username"))
        print("Funcionario: ", patient_employee.get("username"))
        print("Medicamento: ", patient_medicine.get("medicineName"))
        
        return {"patient": patient_qrcode.get("username"), "employee": patient_employee.get("username"), "medicine": patient_medicine.get("medicineName")}, 200

class Flow(Resource):
    # /flow
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        #print("Verificação: ", dados['QRcode_medicine'])


        patient_qrcode = UserModel.find_user_by_qrcode(dados['QRcode_patient'])
        patient_employee = UserModel.find_user_by_qrcode(dados['QRcode_employee'])
        patient_medicine = MedicineModel.find_medicine_qrcode(dados['QRcode_medicine'])



        if patient_qrcode == None:
            return {"message": "Não foi possível encontrar o paciente."}, 400
        elif patient_employee == None:
            return {"message": "Não foi possível encontrar o funcionário."}, 400
        elif patient_medicine == None:
            return {"message": "Não foi possível encontrar o medicamento."}, 400
        

        
        #print("Paciente: ", patient_qrcode.get("username"))
        #print("Funcionario: ", patient_employee.get("username"))
        #print("Medicamento: ", patient_medicine.get("medicineName"))

        time = str(datetime.now(pytz.timezone('America/Sao_Paulo')))


        hashText = hashlib.md5(str(dados['QRcode_patient'] + dados['QRcode_employee'] + dados['QRcode_medicine'] + str(time)).encode("utf-8")).hexdigest()

        print("HASH: ", hashText)

        imagem = qrcode.make(hashText)

        buffer = BytesIO()
        imagem.save(buffer, format = "PNG")

        img_str = str(base64.b64encode(buffer.getvalue()), 'utf-8')
        #print("Paciente: ", patient_qrcode.get("user"))
        #print("Medicamento: ", patient_medicine.get("medicineID"))

        prescription = PrescriptionModel.find_prescription(patient_qrcode.get("user"), patient_medicine.get("medicineID"))
        
        if prescription:
            procedure = ProcedureModel(patient_qrcode.get("user"), patient_employee.get("user"), time, prescription.get("hashText"), img_str, hashText)
            new_procedure = procedure.save_procedure()
        
            return new_procedure
        return {"message": "Não foi possível salvar procedimento."}, 400


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

