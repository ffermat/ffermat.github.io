先SQL跑数

SELECT  `pno` as '运单号' ,`staff_info_id`as '惩罚人员ID', `punish_money` as '罚款',`abnormal_time`as '异常日期'
from `abnormal_message`
WHERE `punish_category` =7
and `abnormal_time`>='2019-10-01'
and `abnormal_time`<='2019-10-31'






拿到数后用下面的代码处理

import pandas as pd 
import numpy as ny 
data=pd.read_csv(r"D:\Onedrive\62，10月丢失件\export_sql_2672251\sqlResult_2672251.csv")

data

data1=data.groupby("惩罚人员ID").sum()
data1
data2=data1.iloc[:,[0]]
data2



data3=data[['惩罚人员ID','运单号']]
data3['运单号'] = data3['运单号'].apply(lambda x:','+ x)
data4=data3.groupby(by='惩罚人员ID')['运单号'].sum()
data4


data5=pd.merge(data2,data4,on="惩罚人员ID")
data5
data5.to_excel(excel_writer=r"C:\Users\JZG\Desktop\十月包裹丢失11.7.xlsx")