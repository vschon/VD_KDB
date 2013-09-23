import q
import kdb
from collections import OrderedDict
import pandas as pd

def qtable2df(qtable):
    '''
    Transfer qtable to pandas dataframe;
    '''
    colnames = qtable.x
    n = len(colnames)
    value = qtable.y
    interdict = OrderedDict()
    for i in range(n):
        interdict[colnames[i]] = value[i]

    return pd.DataFrame(interdict)

