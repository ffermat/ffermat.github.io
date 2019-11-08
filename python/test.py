import pandas as pd
import numpy as nu
from datetime import datetime,date,time
data=pd.read_csv(r"D:\Chrome下载\export_sql_2673132\sqlResult_2673132.csv")
time=data['time']
stime=time.iloc[0]
type(stime)
c_time
c_time=time.strftime('%B %d, %Y, %r')