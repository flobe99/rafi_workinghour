
from pymongo.server_api import ServerApi

from flask import Flask, render_template, request, redirect, url_for, flash
from pymongo import MongoClient
from werkzeug.security import generate_password_hash, check_password_hash


from bson.json_util import dumps
from pymongo.mongo_client import MongoClient
from flask import jsonify, request
from bson.objectid import ObjectId
from datetime import datetime
from urllib.parse import quote_plus


password = quote_plus('GK-12345678')

uri = "mongodb+srv://ufv28642:"+ password +"@cluster0.mzbx1ms.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"


# Create a new client and connect to the server
client = MongoClient(uri)

print("##########################")
print("start ping")
# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

print("##########################")


mongo = client.Auth

app = Flask(__name__)

@app.route('/', methods=['GET'])
def base_route():
    return "asdf"

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        _json = request.json
        _username = _json['username']
        _password = _json['password']
        
        # Check if the username already exists
        if mongo.users.find_one({'username': _username}):
            resp = jsonify("Username already exists. Choose a different one."), 401
        else:
            _hashed_password = generate_password_hash(_password)
            mongo.users.insert_one({'username': _username, 'password': _hashed_password})
            resp = jsonify("Registration successful. You can now log in."), 200
            return resp
        

    return resp

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        _json = request.json
        _username = _json['username']
        _password = _json['password']

        # Check if the username and password match
        user = mongo.users.find_one({'username': _username})
        if check_password_hash(user["password"], _password):
            resp = jsonify("Login successful."), 200
            # Add any additional logic, such as session management
        else:
            resp = jsonify("Invalid username or password. Please try again."), 401

    return resp
