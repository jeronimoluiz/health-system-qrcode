from connection import connect_mongodb
from flask import request


db = connect_mongodb()



class ProcedureModel:
    def __init__(self, patient_id, employee, datetime, prescription, img_qrcode, hashText):
        
        self.user = patient_id
        self.employee = employee
        self.datetime = datetime
        self.prescriptionHashText = prescription
        self.QRCode = img_qrcode
        self.hashText = hashText


        
    @classmethod
    def find_procedure(cls, patient_id):
        
        procedure_vector = []
        
        procedure_found = db.procedure.find({"patientID": patient_id})

        for proc in procedure_found:
            proc.pop("_id")
            
            procedure_vector.append(proc)
        

        if len(procedure_vector) > 0:

            return {"procedure": procedure_vector}
        else:

            return None

    @classmethod
    def find_procedure_qrcode(cls, hash):
        
        procedure_found = db.procedure.find_one({"hashText": hash})
        print("Pesquisa banco: ", procedure_found)

        if procedure_found:
            procedure_found.pop("hashText")
            
            return procedure_found
        else:
            print("Procedimento não encontrado.")
            return None


    def save_procedure(self):

        new_procedure = db.procedure.insert_one({"patientID": self.user, "employee": self.employee, "datetime": self.datetime, "prescriptionHashText": self.prescriptionHashText, "QRCode": self.QRCode, "hashText": self.hashText})
        #print("Nova informação: ", new_procedure)
        if new_procedure:
            return {"messege": "O procedimento foi cadastrado com sucesso!"}, 200
        else:
            return {"message": "Não foi possível cadastrar o procedimento."}, 400
