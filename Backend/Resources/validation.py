#from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
#from Models.medicine import MedicineModel
#from Models.user import UserModel
#from Models.procedures import ProcedureModel
from Models.prescription import PrescriptionModel
import hashlib
import qrcode
#from io import BytesIO
#import base64
from datetime import datetime
#import pytz



atributos = reqparse.RequestParser()
atributos.add_argument('validation_code', type=str, required=True, help="O campo 'validation_code' não pode estar em branco.")




class ValidationQuery(Resource):
    # /validation-document
    def get(self, validation_code):

        print("Código de Validação: ", validation_code)


        document_found = PrescriptionModel.find_prescription_qrcode(validation_code)

        if document_found:
            return {"document": str(document_found.get("prescriptionPDF"))}, 200
        else:
            return {"message": "O código de validação informado não pertence a nenhuma prescrição médica."}, 400