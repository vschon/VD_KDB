import q
import kdb
from collections import OrderedDict
import pandas as pd
import ipdb


def kdblogin(port=5000):
    '''
    shortcut to connect to q server
    '''
    return kdb.q("localhost",port,"")

def qtable2df(qtable):
    '''
    Transfer qtable to pandas dataframe;
    '''
    # add a function to set time as data frame index
    colnames = qtable.x
    n = len(colnames)
    value = qtable.y
    interdict = OrderedDict()
    for i in range(n):
        interdict[colnames[i]] = value[i]

    return pd.DataFrame(interdict)

class dataloader():

    def __init__(self):
        self.conn = kdblogin()

    def load(self,command):
        '''
        load data from different database and return as pd time series
        field is a list of required fields

        command: command send to kdb database
        '''
        result = qtable2df(self.conn.k(command))
        if 'time' in result.columns:
            result.index = result['time']

        return result

    def tickerload(self,source,symbol,begindate,enddate = None):
        '''
        load corresponding data as df
        '''

        if enddate == None:
            enddate = begindate

        range = '(' + begindate + ';' + enddate + ')'

        if source != symbol:
            command = 'select from ' + source + ' where date within ' + range + ',symbol = `' + symbol.upper()
        else:
            command = 'select from ' + source + ' where date within ' + range

        return self.load(command)




