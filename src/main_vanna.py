import certifi_win32 
from dotenv import load_dotenv
from vanna_sql import MyVanna 
from config  import load_config
from vanna.flask import VannaFlaskApp
import os,flask

#loading the .env file

load_dotenv()
print('.env file is loaded  successfully!✅')

#instantiating the vanna class

config=load_config()
vn=MyVanna(config=config)

#connecting it to the database

host = os.getenv("REDSHIFT_HOST")
dbname = os.getenv("REDSHIFT_DB")
user = os.getenv("REDSHIFT_USER")
password = os.getenv("REDSHIFT_PASSWORD")
port = os.getenv("REDSHIFT_PORT", 5439) 

vn.connect_to_postgres(
    host=host,
    dbname=dbname,
    user=user,
    password=password,
    port=int(port))
print("Connected to Redshift✅")


#the UI for the users
app = VannaFlaskApp(vn, allow_llm_to_see_data=True,
                    csv_download=False,
                    chart=False,title='Welcome to Vanna.AI')
app.run()







