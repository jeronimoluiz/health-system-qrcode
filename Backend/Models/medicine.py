from connection import connect_mongodb
from flask import request


db = connect_mongodb()



class MedicineModel:
    def __init__(self, medicine_id, medicine_name = None, manufacturer = None, expiration = None, inventory = None, qr_code_base64 = None, hashText = None):
        
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
    def list_medicine(cls):
        
        medicine_found = db.medicine.find({})
        med_list = []

        for med in medicine_found:
            med.pop("_id")
            med_list.append(med)
            
        return med_list

    @classmethod
    def list_medicine_name(cls):
        
        medicine_found = db.medicine.find({})
        med_list = []

        for med in medicine_found:
            aux = {}
            aux_id = med.pop("medicineID")
            aux_name = med.pop("medicineName")
            med_list.append({"medicineID": aux_id, "medicineName": aux_name})
            
        return med_list

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

    def update_medicine(self):

        new_medicine = None

        if self.medicineName:
            print("Aqui 1: ", self.medicineName)
            new_medicine = db.medicine.update_one({"medicineID": self.medicineID}, {"$set": {"medicineName": self.medicineName}})
        if self.manufacturer:
            print("Aqui 2")
            new_medicine = db.medicine.update_one({"medicineID": self.medicineID}, {"$set": {"manufacturer": self.manufacturer}})
        if self.inventory:
            print("Aqui 3")
            new_medicine = db.medicine.update_one({"medicineID": self.medicineID}, {"$set": {"inventory": self.inventory}})
        if self.expiration:
            print("Aqui 4")
            new_medicine = db.medicine.update_one({"medicineID": self.medicineID}, {"$set": {"expiration": self.expiration}})
        

        if new_medicine:
            return {"messege": "O medicamento foi atualizado com sucesso!"}, 200
        else:
            return {"message": "Não foi possível atualizar o medicamento."}, 400
