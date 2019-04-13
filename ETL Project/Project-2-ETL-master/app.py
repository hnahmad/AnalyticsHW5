from flask import Flask, render_template, redirect, jsonify

import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
import requests
import pymysql
pymysql.install_as_MySQLdb()
from sql_pwd import sql_pwd

import datetime as dt
from datetime import timedelta

connection_string = f'root:{sql_pwd}@localhost/wine_db'
engine = create_engine(f'mysql://{connection_string}')
conn = engine.connect()

# reflect an existing database into a new model
#Base = automap_base()
## reflect the tables
#Base.prepare(engine, reflect=True)

# Save reference to the table
#wine_collection = Base.classes.wine_collection


# Create our session (link) from Python to the DB
session = Session(engine)


# Create an instance of Flask
app = Flask(__name__)



# Route to render index.html template using data from Mongo
@app.route("/")
def home():

    # Query top 10 wine score
#    top_20_wine = session.query(wine_collection.wine, wine_collection.vintage, wine_collection.score).\
#        filter(wine_collection.score !=' ').\
#        order_by(wine_collection.score.desc()).limit(20).all()
    sql = "select * from top_20_wine order by score desc limit 20"
    top_20_wine = pd.read_sql_query(sql, con=engine)
    top_20_wine_df = pd.DataFrame(top_20_wine, columns=['id', 'wine', 'vintage', 'location','score', 'bottles_in_stock'])
#top_20_wine = session.query(top_20_wine, top_20_wine.vintage, top_20_wine.score).limit(20).all()

#    wine=[]
#    vintage=[]
#    score=[]
    
#    for data in top_20_wine:
#        (wine, vintage, score) = data
#        wine.append(wine)
#        vintage.append(vintage)
#        score.append(score)
    
#    top_20_df = top_pd.DataFrame({
#        "wine": wine,
#        "vintage":vintage,
#        "score":score
#    })
    
    top_df = top_20_wine_df[["wine", 'vintage', 'location','score', 'bottles_in_stock']]
    top_df.set_index('wine', inplace=True)
    top_20_html_table = top_df.to_html()
    top_20_html_table = top_20_html_table.replace('\n', '')

    #top_20_wine_json = jsonify(top_20)
    
    
    # Return template and data
    return render_template("index.html", top_20=top_20_html_table)


## Route that will trigger the scrape function
#@app.route("/scrape")
#def scrape():
#    return redirect("/")

# Route that will trigger the scrape function



if __name__ == "__main__":
    app.run(debug=True)
