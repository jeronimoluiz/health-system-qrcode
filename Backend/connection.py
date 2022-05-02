from pymongo import MongoClient
import certifi

url = "localhost"
port = 27017

#uri = "mongodb+srv://admin-tcc:tcc2022@health-system-qrcode.nokkm.mongodb.net/Teste?retryWrites=true&w=majority"

def connect_mongodb():
    client = MongoClient(url, port)
    #client = MongoClient(uri, tlsCAFile=certifi.where())
    db = client.Teste
    return db