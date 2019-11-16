import pandas as pd
import numpy as ny
data=pd.read_excel(r"C:\Users\JZG\Desktop\IMPORT-EXT20191116 - Copy.xlsx")
shortname=pd.read_csv(r"C:\Users\JZG\Desktop\网点缩写对照表.csv")
shortnamelist=list(shortname['short_name'])
data['线路名称']
data['线路名称'] = data['线路名称'].apply(lambda x:'-'+ x)
data1=data['线路名称'].sum()
data2=data1.split("-")
for item in data2:
    if item not in shortnamelist:
        print(item)
print("ok")