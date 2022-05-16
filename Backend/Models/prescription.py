from connection import connect_mongodb
from flask import request
from documents import fill_document


db = connect_mongodb()



class PrescriptionModel:
    def __init__(self, patient_id, doctor, medicine_id, description = None, application_time = None, prescriptionDate = None, qr_code_base64 = None, hashText = None, lastAplicationTime = None):
        
        self.user = patient_id
        self.doctor = doctor
        self.medicineID = medicine_id
        self.description = description
        self.aplicationTime = application_time
        self.prescriptionDate = prescriptionDate
        self.QRCode = qr_code_base64
        self.hashText = hashText
        self.lastAplicationTime = lastAplicationTime


        
    @classmethod
    def find_prescription(cls, patient_id, medicine_id = None):
        
        prescription_vector = []

        if medicine_id != None:
            prescription_found = db.prescription.find({"patientID": patient_id, "medicineID": medicine_id})

            for presc in prescription_found:
                presc.pop("_id")
                #presc.pop("QRCode")
                #presc.pop("hashText")

                prescription_vector.append(presc)

        else:
            prescription_found = db.prescription.find({"patientID": patient_id})

            for presc in prescription_found:
                presc.pop("_id")
                #presc.pop("QRCode")
                #presc.pop("hashText")

                prescription_vector.append(presc)
        

        if prescription_found:
            if len(prescription_vector) > 0 and  medicine_id == None:

                return {"prescription": prescription_vector}
            else:
                return prescription_vector
        else:
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

        json_prescription = {"patientID": self.user, "doctor": self.doctor, "medicineID": self.medicineID, "aplicationTime": self.aplicationTime, "description": self.description, "prescriptionDate": self.prescriptionDate, "QRCode": self.QRCode, "hashText": self.hashText}

        prescription_pdf = fill_document(json_prescription)

        new_prescription = db.prescription.insert_one({"patientID": self.user, "doctor": self.doctor, "medicineID": self.medicineID, "aplicationTime": self.aplicationTime, "description": self.description, "prescriptionDate": self.prescriptionDate, "QRCode": self.QRCode, "hashText": self.hashText, "prescriptionPDF": prescription_pdf, "lastAplicationTime": self.lastAplicationTime})
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
        if self.description:
            print("Aqui 2: ", self.description)
            new_prescription = db.prescription.update_one({"patientID": self.user, "medicineID": self.medicineID}, {"$set": {"description": self.description}})
        if self.lastAplicationTime:
            print("Aqui 3: ", self.lastAplicationTime)
            new_prescription = db.prescription.update_one({"patientID": self.user, "medicineID": self.medicineID}, {"$set": {"lastAplicationTime": self.lastAplicationTime}})
        

        if new_prescription:
            return {"messege": "A prescrição foi atualizada com sucesso!"}, 200
        else:
            return {"message": "Não foi possível atualizar a prescrição."}, 400