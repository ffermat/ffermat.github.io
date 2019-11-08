import pandas as pd
import numpy as nu
import time
import datetime
import seaborn as sns
import matplotlib.pyplot as plt


#导入数据
data=pd.read_csv(r"D:\Chrome下载\export_sql_2673815\sqlResult_2673815.csv")
data


#下单趋势数据
data1=pd.to_datetime(data['ordertime'],format='%Y-%m-%d %H:%M:%S')
data2 =data1.dt.hour
data3 =data1.dt.minute
data4=(data2*100+(data3/60)*100)
data4
data4=data4.dropna()
data4


#揽件趋势数据
ddata1=pd.to_datetime(data['pickuptime'],format='%Y-%m-%d %H:%M:%S')
ddata1
ddata2 =ddata1.dt.hour
ddata3 =ddata1.dt.minute
ddata4=(ddata2*100+(ddata3/60)*100)
ddata4
ddata4=ddata4.dropna()
ddata4


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