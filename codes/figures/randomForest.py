#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec 27 13:42:42 2020

@author: farnazfouladi
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import datasets,svm,metrics
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_curve,auc
from sklearn.model_selection import StratifiedKFold, KFold
from scipy import interp
from itertools import cycle
from sklearn.model_selection import RepeatedKFold
from sklearn.feature_selection import VarianceThreshold
from sklearn.preprocessing import StandardScaler




studies = ['china','RYGB','autism','soil','vaginal']

for study in studies:
    if (study=='china'):
        variable='rural_urban_status'
        label="Urban versus Rural"
    elif (study=='RYGB'):
        variable='time1'
        label="Pre- versus Post-Surgery"
    elif (study=='autism'):
        variable='host_disease'
        label="Autism versus Control"
    elif (study=='soil'):
        variable='ADEversusAGR'
        label="ADE versus AGR"
    else:
        variable='race'
        label='Race'
        
        
    path="/Users/farnazfouladi/git/HashSeq_Manuscript/data/"
    df = pd.read_table(path+study+"/"+study+"_SvTable_norm.txt", header = 0,sep="\t",index_col=0)
    meta = pd.read_table(path+study+"/"+study+"_metaData.txt", header = 0,sep="\t",index_col=0)

# Run classifier with cross-validation and plot ROC curves
#random_state = np.random.RandomState(0)
    cv = RepeatedKFold(n_splits=4, n_repeats=10, random_state=1)
#cv = StratifiedKFold(n_splits=10)
    classifier = RandomForestClassifier(n_estimators=100,random_state=(0))
    constant_filter = VarianceThreshold(threshold=0)
    sc = StandardScaler()




    if(study=="vaginal"):
        df_join = pd.concat([df.reset_index(drop=True),meta.reset_index(drop=True)],axis=1)
        df_join = df_join[(df_join.race=='White')| (df_join.race=='Black')]
        df_join.dropna(subset =['race'],inplace = True)
        meta = df_join.iloc[:,(len(df.columns)+1) : len(df_join.columns)]
        df = df_join.iloc[:,0:len(df.columns)]

    tprs = []
    aucs = []
    mean_fpr = np.linspace(0, 1, 100)

    X = df.iloc[:,0:len(df.columns)]

    X = np.c_[X]
    y = pd.factorize(meta[variable])[0]
    n_samples, n_features = X.shape
    
    for train, test in cv.split(X, y):
    #print(train,test)
    
        X_train = X[train]
        X_test = X[test]
        y_train = y[train]
        y_test = y[test]
        
    
     #Removing taxa with no variance
    #constant_filter.fit(X_train)
    #X_train = constant_filter.transform(X_train)
    #X_test = constant_filter.transform(X_test)
                
     #Scaling
    #X_train = sc.fit_transform(X_train)
    #X_test = sc.transform(X_test)
    
    #Predict
        probas_ = classifier.fit(X_train, y_train).predict_proba(X_test)
        fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1])
        tprs.append(interp(mean_fpr, fpr, tpr))
        tprs[-1][0] = 0.0
        roc_auc = auc(fpr, tpr)
        aucs.append(roc_auc)
    
#DADA2


    cv = RepeatedKFold(n_splits=4, n_repeats=10, random_state=1)
    classifier = RandomForestClassifier(n_estimators=100,random_state=(0))
    constant_filter = VarianceThreshold(threshold=0)
    sc = StandardScaler()

    dada=pd.read_table(path+"DADA2/"+study+"_Dada2Table_norm.txt", header = 0,sep="\t")
    map=pd.read_table(path+"DADA2/"+study+"_metaData.txt", header = 0,sep="\t")


    if(study=="vaginal"):
        dada_join = pd.concat([dada.reset_index(drop=True),map.reset_index(drop=True)],axis=1)
        dada_join = dada_join[(dada_join.race=='White')| (dada_join.race=='Black')]
        dada_join.dropna(subset =['race'],inplace = True)
        map = dada_join.iloc[:,(len(dada.columns)+1) : len(dada_join.columns)]
        dada = dada_join.iloc[:,0:len(dada.columns)]



    tprs_dada = []
    aucs_dada = []
    mean_fpr = np.linspace(0, 1, 100)

    X = dada.iloc[:,0:len(dada.columns)]

    X = np.c_[X]
    y = pd.factorize(map[variable])[0]
    n_samples, n_features = X.shape
    

    for train, test in cv.split(X, y):

    
        X_train = X[train]
        X_test = X[test]
        y_train = y[train]
        y_test = y[test]
    
     #Removing taxa with no variance
    #constant_filter.fit(X_train)
    #X_train = constant_filter.transform(X_train)
    #X_test = constant_filter.transform(X_test)
                
     #Scaling
    #X_train = sc.fit_transform(X_train)
    #X_test = sc.transform(X_test)
    
    #Predict
        probas_ = classifier.fit(X_train, y_train).predict_proba(X_test)
        fpr, tpr, thresholds = roc_curve(y_test, probas_[:, 1])
        tprs_dada.append(interp(mean_fpr, fpr, tpr))
        tprs_dada[-1][0] = 0.0
        roc_auc = auc(fpr, tpr)
        aucs_dada.append(roc_auc)
    
    
    fig = plt.figure()
    plt.plot([0, 1], [0, 1], linestyle='--', lw=2, color='black', alpha=.8)

    mean_tpr = np.mean(tprs, axis=0)
    mean_tpr[-1] = 1.0
    mean_auc = auc(mean_fpr, mean_tpr)
    std_auc = np.std(aucs)

    mean_tpr_dada = np.mean(tprs_dada, axis=0)
    mean_tpr_dada[-1] = 1.0
    mean_auc_dada = auc(mean_fpr, mean_tpr_dada)
    std_auc_dada = np.std(aucs_dada)


    plt.plot(mean_fpr, mean_tpr, color='#E6AB02',
             label=r'HashSeq-Mean ROC (AUC = %0.3f $\pm$ %0.3f)' % (mean_auc, std_auc),
             lw=3, alpha=.8)


    plt.plot(mean_fpr, mean_tpr_dada, color='#7570B3',
             label=r'Dada2-Mean ROC (AUC = %0.3f $\pm$ %0.3f)' % (mean_auc_dada, std_auc_dada),
             lw=3, alpha=.8)

    std_tpr = np.std(tprs, axis=0)
    tprs_upper = np.minimum(mean_tpr + std_tpr, 1)
    tprs_lower = np.maximum(mean_tpr - std_tpr, 0)
    plt.fill_between(mean_fpr, tprs_lower, tprs_upper, color='grey', alpha=.2)


    std_tpr_dada = np.std(tprs_dada, axis=0)
    tprs_upper_dada = np.minimum(mean_tpr_dada + std_tpr_dada, 1)
    tprs_lower_dada = np.maximum(mean_tpr_dada - std_tpr_dada, 0)
    plt.fill_between(mean_fpr, tprs_lower_dada, tprs_upper_dada, color='grey', alpha=.2)


    plt.xlim([-0.05, 1.05])
    plt.ylim([-0.05, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title(label)
    plt.legend(loc="lower right",prop={'size': 7})
    fig.savefig('/Users/farnazfouladi/git/HashSeq_Manuscript/figures/'+'ROC_'+study+'.pdf', bbox_inches='tight')
    plt.show()







 










































