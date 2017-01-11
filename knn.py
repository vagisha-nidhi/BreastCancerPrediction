
# coding: utf-8

# In[ ]:




# In[ ]:




# In[ ]:




# In[122]:

import numpy as np


# In[ ]:




# In[123]:




# In[ ]:




# In[124]:

import pandas as pd


# In[129]:

df = pd.read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data", names=['Id', 'ClumpThickness', 'UniformityCellSize', 'UniformityCellShape', 'MarginalAdhesion', 'EpithelialCellSize', 'BareNuclei', 'BlandChromatin', 'NormalNucleoli', 'Mitoses','Class'])


# In[ ]:

print df


# In[130]:

df.head()


# In[131]:

benign = df.loc[df['Class']==2]
benign.describe()
benign.head()


# In[ ]:

get_ipython().magic(u'matplotlib inline')

import matplotlib.pyplot as plt
import seaborn as sb
sb.pairplot(df.dropna(),hue='Class')


# In[ ]:




# In[126]:

import sklearn.cross_validation
import sklearn.grid_search
import sklearn.metrics
import sklearn.neighbors
import sklearn.decomposition
import sklearn
import sklearn.datasets

X = df.iloc[0:699,1:10]
Y = df.iloc[0:699,-1:]

print X.shape, Y.shape


# In[39]:

X_train, X_test, Y_train, Y_test = sklearn.cross_validation.train_test_split(X,Y,test_size=0.33,random_state=42)


# In[40]:

X_train


# In[41]:


X_norm = np.mean(X_train,axis=0)
X_norm
print X_norm


# In[45]:


k = np.arange(20)+1
parameters = {'n_neighbors': k}
knn = sklearn.neighbors.KNeighborsClassifier()
clf = sklearn.grid_search.GridSearchCV(knn,parameters,cv=10)
print Y_train.shape
print X_train.shape
clf


# In[119]:

X_train_numpy = X_train.values
Y_train_numpy = Y_train.values
X_train_numpy = X_train_numpy.astype(int)
X_test_numpy = X_test.values
Y_test_numpy= Y_test.values
Y_test_numpy = np.reshape(Y_test_numpy,(231,))
X_test_numpy = X_test_numpy.astype(int)

Y_train_numpy = np.reshape(Y_train_numpy,(468,))
Y_train_numpy
X_train_numpy


# In[116]:

clf.fit(X_train_numpy,Y_train_numpy)


# In[117]:

clf.best_params_


# In[121]:

sklearn.metrics.accuracy_score(Y_test_numpy,clf.predict(X_test_numpy))


# In[ ]:




# In[ ]:




# In[ ]:




# In[118]:

Y_test.shape


# In[ ]:



