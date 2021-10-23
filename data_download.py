import datetime as dt
import numpy as np
import pandas_datareader as web


start = dt.datetime(1800,1,1)
end = dt.datetime.now()
df = web.DataReader('^GSPC', 'yahoo', start, end)

df['Diff_close'] = ((df['Close'] - df['Close'].shift(1)) / df['Close'].shift(1)).fillna(0) + 1
df['Cum_Diff_close'] = np.cumprod(df['Diff_close'])

df.to_csv('SP500.csv')