from connection import connect_mongodb



db = connect_mongodb()



class EmergencyInfoModel:
    def __init__(self, user_id, address, name, bloodType, emergencyContact, allergies = None, medicines = None, healthInfo = None, organDonor = None):
        
        self.user = user_id
        self.address = address
        self.name = name
        self.bloodType = bloodType
        self.allergies = allergies
        self.medicines = medicines
        self.healthInfo = healthInfo
        self.organDonor = organDonor
        self.emergencyContact = emergencyContact
        
    @classmethod
    def find_emergency_info(cls, user_id):
        
        emergency_info_found = db.emergencyInfo.find_one({"user": user_id})
        print("Pesquisa banco: ", emergency_info_found)

        if emergency_info_found:
            emergency_info_found.pop("_id")
            
            return emergency_info_found
        else:
            #print("Usuário não encontrado")
            return None


    def save_emergency_info(self):
        
        #print("Counteúdo de self: ", self)

        new_emergency_info = db.emergencyInfo.insert_one({"user": self.user, "name": self.name, "address": self.address, "bloodType": self.bloodType, "allergies": self.allergies, "medicines": self.medicines, "healthInfo": self.healthInfo, "organDonor": self.organDonor, "emergencyContact": self.emergencyContact})
        #print("Nova informação: ", new_emergency_info)
        if new_emergency_info:
            return {"messege": "As informações de emergência foram cadastradas com sucesso!"}, 200
        else:
            #print("Não foi possível criar usuário.")
            return {"message": "Não foi possível cadastrar as informações de emergência."}, 400