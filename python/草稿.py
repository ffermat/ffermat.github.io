import pandas as pd
import numpy as np
fajianliang=pd.read_csv(r"D:\Chrome下载\export_sql_2662895\sqlResult_2662895.csv")
fajianliang.head(10)
import matplotlib.pyplot as plt
import scipy as sp
fajianliang['columnss'].plot.hist(bins=10)
plt.show()
fajianliang?