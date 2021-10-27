import datetime as dt
import numpy as np
import pandas as pd
import pandas_datareader as web

days_year = 252
start = dt.datetime(1920,1,1)
end = dt.datetime.now()

df_sp500 = web.DataReader('^GSPC', 'yahoo', start, end)


df_sp500['date'] = df_sp500.index
df_sp500['date'] = pd.to_datetime(df_sp500['date']).dt.strftime('%Y%m%d').astype(int)
df_sp500 = df_sp500[['date', 'High', 'Low', 'Open', 'Close', 'Volume', 'Adj Close']]

df_sp500['Diff_close'] = ((df_sp500['Close'] - df_sp500['Close'].shift(1)) / df_sp500['Close'].shift(1)).fillna(0) + 1
df_sp500['Cum_Diff_close'] = np.cumprod(df_sp500['Diff_close'])


df_div = pd.read_csv('divs_anual.csv')
df_div['Daily_yield'] = (df_div['Yield']  / 100 + 1) ** (1 / days_year)
df_div = df_div.drop(['Date', 'Yield'], axis=1)

df_sp500['Daily_div'] = 0
for year in range(2021, 1920, -1):
    daily_yield = df_div.loc[df_div['Year'] == year, 'Daily_yield'].values[0]
    df_sp500.loc[df_sp500['date'] < (year + 1) * 1e+4, 'Daily_div'] = daily_yield


df_sp500['Diff_close_div'] = df_sp500['Diff_close'] * df_sp500['Daily_div']
df_sp500['Cum_Diff_close_div'] = np.cumprod(df_sp500['Diff_close_div'])

df_sp500.to_csv('SP500.csv')
# df_div.to_csv('divs.csv')