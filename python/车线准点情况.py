import pandas as pd
import numpy as ny
data=pd.read_excel(r"D:\Chrome下载\dc_excel_zh-CN20191106-093556.xlsx")
data1=data[["打印出车凭证时间","线路属性","线路名称","所属区域","出车凭证编码","车牌号","发车网点","考勤类型.1","计划到达时间","实际到达时间","考勤状态","到达超时"]]
data1