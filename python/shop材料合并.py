#shop全员##################################
import pandas as pd
import numpy as ny
chuqin=pd.read_csv(r"D:\Chrome下载\sqlresult_4410820.csv")
chuqin["mark"]=chuqin["员工工号"].astype(str)+chuqin["统计日期"]
lanjian=pd.read_csv(r"D:\Chrome下载\sqlresult_4410821.csv")
lanjian["mark"]=lanjian["staffid"].astype(str)+lanjian["pickupdate"]
lanjian1=lanjian[['total', 'ka', 'user','不需换单的量', '不需换单的ka量', '不需换单的user量', '需换单总量', '需换未换单量', '已换单量','换单操作人是自己的单量', '换单操作人是自己的ka单量', '换单操作人是自己的user单量', '换单操作人是别人的单量','换单操作人是别人的ka单量', '换单操作人是别人的user单量', 'mark']]
hebing=pd.merge(chuqin,lanjian1,on="mark",how="left")
hebing1=hebing[['员工工号', '职位名', '所属网点', '网点名', '统计日期', '出勤情况', '有效出勤时间', '上班打卡时间','下班打卡时间', 'total', 'ka', 'user', '不需换单的量', '不需换单的ka量','不需换单的user量', '需换单总量', '需换未换单量', '已换单量', '换单操作人是自己的单量', '换单操作人是自己的ka单量','换单操作人是自己的user单量', '换单操作人是别人的单量', '换单操作人是别人的ka单量', '换单操作人是别人的user单量']]
hebing1.to_excel(excel_writer=r"D:\Onedrive\2，每日导数\梦雨导数\11.8-11.17.xlsx")
###########################################