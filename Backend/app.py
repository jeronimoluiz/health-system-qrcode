import os
from flask_cors import CORS
from Resources.user import User, UserRegister, UserLogin, UserUpdate
from Resources.patient import EmergencyInfoRegister, EmergencyInfo, MakeEmergencyInfoQRCode, ReadEmergencyInfoQRCode
from Resources.medicine import Medicine, MedicineRegister, MedicineQRCode, MedicineList, MedicineListName, MedicineUpdate
from Resources.prescription import PrescriptionRegister, PrescriptionUser, Prescription, PrescriptionQRCode, PrescriptionUpdate
from Resources.flow import Flow, FlowQuery
from flask import Flask, jsonify, g, request
from flask_restful import Resource, Api
from connection import connect_mongodb
from datetime import datetime
import time
import json




app = Flask(__name__)
api = Api(app)

cors = CORS(app, resource={r"/*":{"origins": "*"}})

@app.route("/", methods=['GET'])
def index():
    return "<h1>Hello World</h1>"


@app.route("/deploy", methods=['GET'])
def deploy():
    return "<h1>Tetando deploy GitHub x Heroku</h1>"




def main():
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)


api.add_resource(UserRegister, '/register', methods=['POST'])
api.add_resource(UserLogin, '/login', methods=['POST'])
api.add_resource(UserUpdate, '/user-update', methods=['POST'])

api.add_resource(User, '/user/<string:user>', methods=['GET'])

api.add_resource(EmergencyInfoRegister, '/emergency-info-register', methods=['POST'])
api.add_resource(EmergencyInfo, '/emergency-info/<string:user>', methods=['GET'])
api.add_resource(MakeEmergencyInfoQRCode, '/emergency-info-qrcode/<string:user>', methods=['GET'])
api.add_resource(ReadEmergencyInfoQRCode, '/emergency-info-qrcode-read/<string:hash>', methods=['GET'])


api.add_resource(MedicineRegister, '/medicine-register', methods=['POST'])
api.add_resource(MedicineUpdate, '/medicine-update', methods=['POST'])
api.add_resource(Medicine, '/medicine/<string:medicine_id>', methods=['GET'])
api.add_resource(MedicineQRCode, '/medicine-qrcode/<string:medicine_id>', methods=['GET'])
api.add_resource(MedicineList, '/medicine-list', methods=['GET'])
api.add_resource(MedicineListName, '/medicine-list-name', methods=['GET'])


api.add_resource(PrescriptionRegister, '/prescription-register', methods=['POST'])
api.add_resource(PrescriptionUpdate, '/prescription-update', methods=['POST'])
api.add_resource(PrescriptionUser, '/prescription/<string:user>', methods=['GET'])
api.add_resource(Prescription, '/prescription/<string:user>/<string:medicine_id>', methods=['GET'])
api.add_resource(PrescriptionQRCode, '/prescription-qrcode/<string:user>/<string:medicine_id>', methods=['GET'])


api.add_resource(FlowQuery, '/flow-query/<string:QRcode_patient>/<string:QRcode_employee>/<string:QRcode_medicine>', methods=['GET'])
api.add_resource(Flow, '/flow', methods=['POST'])


if __name__ == "__main__":
    #main()
    app.run(debug=True)