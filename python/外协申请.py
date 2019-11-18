import pandas as pd
import numpy as ny
shenqing=pd.read_csv(r"D:\Chrome下载\sqlresult_4412904.csv")
shenqing=shenqing.drop_duplicates(["store_id","job_title"])
wangdian=pd.read_csv(r"D:\Onedrive\1，常用表格\sys_store 10.26.csv")
wangdian1=wangdian.iloc[:,[0,6]]
banci=pd.read_excel(r"D:\Onedrive\1，常用表格\hr_shift.xlsx")
hebingshuju1=pd.merge(shenqing,wangdian1,left_on="store_id",right_on="id",how="left")
hebingshuju1.head(3)
hebingshuju2=pd.merge(hebingshuju1,banci,left_on="shift_id",right_on="id",how="left")
hebingshuju2.columns
jieguo=hebingshuju2[[ 'applicant', 'store_id','name', 'job_title', 'employment_date','employment_days', 'final_audit_num','shift_id',   'type', 'start', 'end', 'created_at']]
jieguo=jieguo.rename(columns={"name":"store_name"})
#jieguo=jieguo.sort_values(by=["created_at"],ascending=[True])
jieguo
jieguo.to_excel(excel_writer=r"D:\Onedrive\0，存档10.29之前\33，外协员工需求\外协员工需求11.18_v1.xlsx")
