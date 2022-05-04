from connection import connect_mongodb
from flask import request


db = connect_mongodb()



class PrescriptionModel:
    def __init__(self, patient_id, doctor, medicine_id, application_time = None, prescriptionHashText = None, qr_code_base64 = None, hashText = None):
        
        self.user = patient_id
        self.doctor = doctor
        self.medicineID = medicine_id
        self.aplicationTime = application_time
        self.prescriptionHashText = prescriptionHashText
        self.QRCode = qr_code_base64
        self.hashText = hashText


        
    @classmethod
    def find_prescription(cls, patient_id, medicine_id = None):
        
        prescription_vector = []

        if medicine_id != None:
            prescription_found = db.prescription.find_one({"patientID": patient_id, "medicineID": medicine_id})
        else:
            prescription_found = db.prescription.find({"patientID": patient_id})

            for presc in prescription_found:
                presc.pop("_id")
                #presc.pop("QRCode")
                #presc.pop("hashText")

                prescription_vector.append(presc)
        

        if prescription_found:
            if len(prescription_vector) > 0:

                return {"prescription": prescription_vector}
            else:
                prescription_found.pop("_id")
                #prescription_found.pop("QRCode")
                #prescription_found.pop("hashText")
                
                return prescription_found
        else:
            #print("Usuário não encontrado")
            return None

    @classmethod
    def find_prescription_qrcode(cls, hash):
        
        prescription_found = db.prescription.find_one({"hashText": hash})
        print("Pesquisa banco: ", prescription_found)

        if prescription_found:
            prescription_found.pop("hashText")
            
            return prescription_found
        else:
            print("Prescrição não encontrada.")
            return None


    def save_prescription(self):

        new_prescription = db.prescription.insert_one({"patientID": self.user, "doctor": self.doctor, "medicineID": self.medicineID, "aplicationTime": self.aplicationTime, "prescriptionHashText": self.prescriptionHashText, "QRCode": self.QRCode, "hashText": self.hashText})
        #print("Nova informação: ", new_prescription)
        if new_prescription:
            return {"messege": "A nova prescrição foi cadastrada com sucesso!"}, 200
        else:
            return {"message": "Não foi possível cadastrar a prescrição."}, 400

    
    def update_prescription(self):

        new_prescription = None

        if self.aplicationTime:
            print("Aqui 1: ", self.aplicationTime)
            new_prescription = db.prescription.update_one({"patientID": self.user, "medicineID": self.medicineID}, {"$set": {"aplicationTime": self.aplicationTime}})
        

        if new_prescription:
            return {"messege": "A prescrição foi atualizada com sucesso!"}, 200
        else:
            return {"message": "Não foi possível atualizar a prescrição."}, 400