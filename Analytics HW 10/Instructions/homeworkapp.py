from flask import Flask,jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return "Welcome to the climate app API<br/>"

        f"Available Routes:<br/>"
        f"/api/v1.0/climate-app"