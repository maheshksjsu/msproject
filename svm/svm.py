import numpy as np
import math
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import svm
import sklearn.metrics as metric
import os, sys, time
from mlxtend.plotting import plot_decision_regions
from sklearn.decomposition import PCA


train_data_file='dataset.csv'
pred_data_file='predict_dataset.csv'
test_index=990
svc = None

def predict_result():
    global pred_data_file
    global svc

    print('predict_resuilt()')
    pred_data=pd.read_csv(pred_data_file)
    _X_predict=np.array(pred_data)
    print(_X_predict[:,1:])
    X_predict=_X_predict[:,1:]
    print('---------')

    print('---PREDICTING NOW---')
    print('predicting on:')
    print(X_predict)
    y_pred=svc.predict(X_predict)
    print(y_pred)
    for i in range(len(y_pred)):
        if y_pred[i] == +1:
            stream_pcap = os.path.join('processed',_X_predict[i,0])
            print()
            print('===========================================')
            print('Following traffic is predicted as Mirai')
            os.system('tcpick -C -yP -r %s'%(stream_pcap))
            print('===========================================')
            print()
            print()
    if +1 in y_pred:
        return True
    else:
        print('no malware detected in this poll')
    return False

def train_model():
    global train_data_file
    global test_index
    global svc

    print('train_model()')
    train_data=pd.read_csv(train_data_file)
    test_index=990

    _X_training=np.array(train_data)
    X_training=_X_training[:test_index,1:-1]
    X_test=_X_training[test_index:,1:-1]
    print('X_training')
    print(X_training)
    y_training=train_data['MIRAI'][:test_index]
    y_test=train_data['MIRAI'][test_index:]
    print('y_training')
    print(y_training)
    print('y_test')
    print(y_test)
    target_names=['-1','+1']

    #plot the data
    idxPlus=y_training[y_training<0].index
    idxMin=y_training[y_training>0].index
    plt.scatter(X_training[idxPlus,0],X_training[idxPlus,1],c='b',s=50)
    plt.scatter(X_training[idxMin,0],X_training[idxMin,1],c='r',s=50)
    plt.legend(target_names,loc=2)
    plt.xlabel('X1')
    plt.ylabel('X2');
    plt.savefig('chart0.png')
    plt.show()

    svc = svm.SVC(kernel='linear').fit(X_training,y_training)
    print('----SVM SVC----')
    print('n_support:')
    print(svc.n_support_)

    print('support_vectors:')
    print(svc.support_vectors_)
    print('----SVM----')

    print('testing on:')
    print(X_test)
    print('Exepcted result:')
    print(y_test)
    X_test_predict = np.array(X_test)
    y_test_pred=svc.predict(X_test_predict)
    print('Actual result')
    print(y_test_pred)

def download_dataset():
    os.system('./download.sh')


if __name__ == '__main__':
    train_model()
    while True:
        print('back to loop')
        download_dataset()
        if os.path.isfile(pred_data_file):
            try:
                if predict_result() == True:
                    os.system('ssh -i aws-keys.pem ubuntu@ec2-3-16-53-88.us-east-2.compute.amazonaws.com touch /tmp/do_reset')
                    print('notified to reset honeypot')
                else:
                    os.system('ssh -i aws-keys.pem ubuntu@ec2-3-16-53-88.us-east-2.compute.amazonaws.com touch /tmp/do_remove')
            except:
                print('exception')
                sys.exit(1)
            os.remove(pred_data_file)
            print('removed predict_dataset.csv')
        time.sleep(10)

