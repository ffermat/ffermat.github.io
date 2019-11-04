import pandas as pd
import numpy as np
data=pd.read_excel(r"D:\Onedrive\62，10月提成汇总单号\HUB罚款项.xlsx",sheet_name="包裹破损")
data=data[['惩罚人员ID','运单号']]
data['运单号'] = data['运单号'].apply(lambda x:','+ x)
data
data1=data.groupby(by='惩罚人员ID')['运单号'].sum()
data1
data1.to_excel(excel_writer=r"D:\Onedrive\62，10月提成汇总单号\包裹破损汇总单号_v2.xlsx")