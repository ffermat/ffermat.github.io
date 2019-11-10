import pandas as pd
import numpy as nu
data=pd.read_csv(r"D:\Chrome下载\export_sql_2675238\sqlResult_2675238.csv")
data[data.pno.isin(['TH27203EPRX8D','TH31013EM242J'])]
data1=data.copy()
list(data.weight.unique())
