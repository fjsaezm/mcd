from matplotlib import pyplot as plt 
import numpy as np 
import pandas as pd 

from os import listdir
from os.path import isfile, join
mypath = 'Results/'
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

x = np.arange(1,20,1)
dfs = []

for f in onlyfiles:
    print(f)
    df = pd.read_csv(mypath+f, header = None,names = x).round(2)
    dfs.append(df)
    
    half = df.iloc[:, :10]
    o_half = df.iloc[:, 10:]
    
    print(half.to_latex())
    print(o_half.to_latex())
    print("\n-------------\n")

for df,name in zip(dfs,onlyfiles):
    plt.plot(x, df.iloc[0],label = name.split(".")[0])


plt.legend()
plt.title("Legend is: window-margin-validation window")
plt.savefig("Results.pdf")
plt.show()


quit()


optimal = pd.read_csv('Results/3-13-3.csv', header = None, names = x).round(2)
val = pd.read_csv('Results/3-13-1.csv', header = None, names = x).round(2)
window = pd.read_csv('Results/5-5-1.csv', header = None, names = x).round(2)

plt.plot(x,optimal.iloc[0],color = "red",label = "3-13-1")
plt.plot(x,val.iloc[0],color = "blue",label = "3-13-3")
plt.plot(x,window.iloc[0],color = "black", label = "5-5-1")
plt.legend()

plt.savefig("Results.pdf")
plt.show()
