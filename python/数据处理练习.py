import pandas as pd
data=pd.read_csv(r"D:\Onedrive\1，常用表格\sys_store 10.26.csv")
data.columns
data1=data[['id', 'ancestry', 'category']]
data1
data2=data1.rename(columns={"id":"idd","ancestry":"asdfasdf"})
data2
data2.shape
data2.info()
data2.describe()