from jwtRSA import create_token, token_required
from flask_restful import Resource, reqparse
from Models.patient import EmergencyInfoModel


atributos = reqparse.RequestParser()
atributos.add_argument('user', type=str, required=True, help="O campo usuário não pode estar em branco.")
atributos.add_argument('name', type=str, required=True, help="O campo name não pode estar em branco.")
atributos.add_argument('address', type=str, required=True, help="O campo address não pode estar em branco.")
atributos.add_argument('bloodType', type=str, required=True, help="O campo bloodType não pode estar em branco.")
atributos.add_argument('emergencyContact', type=str, required=True, help="O campo emergencyContact não pode estar em branco.")
atributos.add_argument('allergies', type=str, required=False)
atributos.add_argument('medicines', type=str, required=False)
atributos.add_argument('healthInfo', type=str, required=False)
atributos.add_argument('organDonor', type=str, required=False)



class EmergencyInfoRegister(Resource):
    # /emergency-info-register
    @token_required
    def post(self, data):
        
        dados = atributos.parse_args()
        print(dados)

        if EmergencyInfoModel.find_emergency_info(dados['user']):
            return {"message": "As informações de emergência já foram cadastradas."}, 400
        print("Nova Info emergência: ", dados)
        emergency_info = EmergencyInfoModel(dados['user'], dados['address'], dados['name'], dados['bloodType'], dados['emergencyContact'], dados['allergies'], dados['medicines'], dados['healthInfo'], dados['organDonor'])
        new_emergency_info = emergency_info.save_emergency_info()
        
        
        return new_emergency_info


class EmergencyInfo(Resource):  
    # /emergency-info/{user}
    @token_required
    def get(self, data, user):
        
        user = EmergencyInfoModel.find_emergency_info(user)
        
        if user:
            
            return user, 200
        return {'message':'Usuário não encontrado.'}, 404 # Not found