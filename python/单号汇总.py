import pandas as pd
import numpy as np
data=pd.read_excel(r"D:\Onedrive\62，10月提成汇总单号\HUB罚款项.xlsx",sheet_name="包裹破损")
data=data[['惩罚人员ID','运单号']]
data['运单号'] = data['运单号'].apply(lambda x:','+ x)
data
data1=data.groupby(by='惩罚人员ID')['运单号'].sum()
data1
data1.to_excel(excel_writer=r"D:\Onedrive\62，10月提成汇总单号\包裹破损汇总单号_v2.xlsx")




import pandas as pd
import numpy as np
data=pd.read_excel(r"C:\Users\JZG\Desktop\hub.xlsx")
data
data1=data.groupby(by='store')['pno'].sum()
data1.to_excel(excel_writer=r"C:\Users\JZG\Desktop\test.xlsx")
data1.index
data1.store

hub01=data1[0]
hub01=hub01.split(',')
hub01 = list(set(hub01))
hub01=",".join(hub01)

hub01test=",".join(list(set(data1[0].split(','))))
hub02test=",".join(list(set(data1[1].split(','))))
hub03test=",".join(list(set(data1[2].split(','))))
hub04test=",".join(list(set(data1[3].split(','))))
hub05test=",".join(list(set(data1[4].split(','))))
hub06test=",".join(list(set(data1[5].split(','))))
hub07test=",".join(list(set(data1[6].split(','))))
hub08test=",".join(list(set(data1[7].split(','))))

dataok={'store':['01 BKK_HUB-จตุโชติ', '02 NE1_HUB-นครราชสีมา','03 SO1_HUB-สุราษฏร์ธานี', '04 NO1_HUB-นครสวรรค์', '05 LAS_HUB-ลาซาล','06 LPT_HUB-ลำปาง', '09 KKC_HUB - ขอนแก่น', '12 SO2_HUB - หาดใหญ่'],'pno':[hub01test,hub02test,hub03test,hub04test,hub05test,hub06test,hub07test,hub08test]}
dataokk=pd.DataFrame(dataok)
dataokk

dataokk.to_excel(excel_writer=r"C:\Users\JZG\Desktop\hubpno.xlsx")