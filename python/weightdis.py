import pandas as pd
import numpy as nu
import time
import datetime
import seaborn as sns
import matplotlib.pyplot as plt


#导入数据
data=pd.read_csv(r"D:\Chrome下载\export_sql_2675238\sqlResult_2675238.csv")
data



#下单趋势数据


data4=data["weight"]
data4=data4.dropna()
data4.describe([0.5,0.6,0.7,0.8,0.9,0.95])
pd.options.display.float_format = "{:.2f}".format




#揽件趋势数据
ddata1=pd.to_datetime(data['pickuptime'],format='%Y-%m-%d %H:%M:%S')
ddata1
ddata2 =ddata1.dt.hour
ddata3 =ddata1.dt.minute
ddata4=(ddata2*100+(ddata3/60)*100)
ddata4
ddata4=ddata4.dropna()
ddata4
ddata4.describe([0.5,0.6,0.7,0.8,0.9,0.95])


ddd= pd.concat([data4, ddata4], axis=1)
ddd




#df = sns.load_dataset('iris')
# plot of 2 variables

p1=sns.kdeplot(data4, shade=True, color="r")
p1=sns.kdeplot(ddata4, shade=True, color="b")
plt.show()
#sns.plt.show()





data['ordertime']=pd.to_datetime(data['ordertime'],format='%Y-%m-%d %H:%M:%S')
data