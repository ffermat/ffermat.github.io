

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import datetime as dt

data=pd.read_csv(r"C:\Users\JZG\Desktop\export_sql_2663112\sqlResult_2663112.csv")
data.head()
data1=data['created_at']
data1=dt.time(data1)
data1
sns.kdeplot(data1)
plt.show()

data1.describe()