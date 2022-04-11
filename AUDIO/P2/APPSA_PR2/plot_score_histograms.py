import numpy as np
import matplotlib.pyplot as plt

scores_file = 'exps/test/result/scores_test.txt' # Modify to point at your scores file 
keys_file = 'lists/veri_test.txt'

all_scores = np.loadtxt(scores_file, usecols=[0])
all_trials_scores = np.loadtxt(scores_file, usecols=[1,2], dtype='str')

all_keys = np.loadtxt(keys_file, usecols=[0])
all_trials_keys = np.loadtxt(keys_file, usecols=[1,2], dtype='str')


target_scores = all_scores[all_keys==1]
nontarget_scores = all_scores[all_keys==0]


plt.hist(target_scores, alpha=0.7)
plt.hist(nontarget_scores, alpha=0.7)

plt.xlabel('score')
plt.legend(('target','non target')) 
plt.show()



