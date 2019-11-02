import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

data=pd.read_csv(r"D:\Chrome下载\sqlresult_4354646.csv")
data.head()
data1=data['columnss']
data1.head()
sns.kdeplot(data1)
plt.show()