import pandas as pd 
import numpy as ny 
data=pd.read_csv(r"D:\Chrome下载\export_sql_2668247\sqlResult_2668247.csv")
data.head()
data1=data.groupby("lose_task_id").sum()
data1.head()
data1["duty_ratio"].describe()
data2=data1.sort_values(by=["duty_ratio"],ascending=False)
data2
data2.to_excel(excel_writer=r"D:\Onedrive\62，10月丢失件\look.xlsx")   