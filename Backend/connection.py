from pymongo import MongoClient

url = "mongodb+srv://admin-tcc:tcc2022@health-system-qrcode.nokkm.mongodb.net/users?retryWrites=true&w=majority"
port = 27017

def connect_mongodb():
    client = MongoClient(url, port)
    db = client.Teste
    return db