import os
from flask import Flask
from flask_restful import Resource, Api
from flask_cors import CORS


import pymongo
from connection import connect_mongodb
from blacklist import BLACKLIST
from Resources.user import User, UserRegister, UserLogin, UserLogout




app = Flask(__name__)
api = Api(app)

cors = CORS(app, resource={r"/*":{"origins": "*"}})

@app.route("/", methods=['GET'])
def index():
    return "<h1>Hello World</h1>"


@app.route("/deploy", methods=['GET'])
def deploy():
    return "<h1>Tetando deploy GitHub x Heroku</h1>"



'''
def main():
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
'''

api.add_resource(UserRegister, '/register')
api.add_resource(UserLogin, '/login')
api.add_resource(UserLogout, '/logout')


if __name__ == "__main__":
    #main()
    app.run(debug=True)