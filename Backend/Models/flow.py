from connection import connect_mongodb
from flask import request


db = connect_mongodb()



class MedicineModel:
    def __init__(self, medicine_id, medicine_name, manufacturer, expiration, inventory, qr_code_base64, hashText):
        
        self.medicineID = medicine_id
        self.medicineName = medicine_name
        self.manufacturer = manufacturer
        self.inventory = inventory
        self.expiration = expiration
        self.QRCode = qr_code_base64
        self.hashText = hashText


        
    @classmethod
    def find_medicine(cls, medicine_id):
        
        medicine_found = db.medicine.find_one({"medicineID": medicine_id})
        print("Pesquisa medicine: ", medicine_found)

        if medicine_found:
            medicine_found.pop("_id")
            
            return medicine_found
        else:
            #print("Usuário não encontrado")
            return None

    @classmethod
    def find_medicine_qrcode(cls, hash):
        
        medicine_found = db.medicine.find_one({"hashText": hash})
        print("Pesquisa banco: ", medicine_found)

        if medicine_found:
            medicine_found.pop("hashText")
            
            return medicine_found
        else:
            print("Medicamento não encontrado.")
            return None


    def save_medicine(self):

        new_medicine = db.medicine.insert_one({"medicineID": self.medicineID, "medicineName": self.medicineName, "manufacturer": self.manufacturer, "expiration": self.expiration, "inventory": self.inventory, "QRCode": self.QRCode, "hashText": self.hashText})
        #print("Nova informação: ", new_medicine)
        if new_medicine:
            return {"messege": "O novo medicamento foi cadastrado com sucesso!"}, 200
        else:
            return {"message": "Não foi possível cadastrar o medicamento."}, 400
