import os
from flask_cors import CORS
from Resources.user import User, UserRegister, UserLogin, UserUpdate
from Resources.patient import EmergencyInfoRegister, EmergencyInfo, MakeEmergencyInfoQRCode, ReadEmergencyInfoQRCode
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


if __name__ == "__main__":
    main()
    #app.run(debug=True)
