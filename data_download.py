import datetime as dt
import numpy as np
import pandas as pd
import pandas_datareader as web

# Initialize start and end dates of the historical data
# We start at 1800 to download as much data as possible
start = dt.datetime(1800, 1, 1)
end = dt.datetime.now()

# Download the data
df_sp500 = web.DataReader('^GSPC', 'yahoo', start, end)

# Add index to dataframe as a column
df_sp500['date'] = df_sp500.index
# Change the date format
df_sp500['date'] = pd.to_datetime(df_sp500['date']).dt.strftime('%Y%m%d').astype(int)
# Reorder columns
df_sp500 = df_sp500[['date', 'High', 'Low', 'Open', 'Close', 'Volume', 'Adj Close']]

# Get the relative increases of closing price
df_sp500['Diff_close'] = ((df_sp500['Close'] - df_sp500['Close'].shift(1)) / df_sp500['Close'].shift(1)).fillna(0) + 1
# Get the cumulative increases of closing price
df_sp500['Cum_Diff_close'] = np.cumprod(df_sp500['Diff_close'])

# Initialize the opening market days of a year
days_year = 252

# Load the annual dividens yield data
df_div = pd.read_csv('annual_div.csv')
# Calculate the daily dividens yield
df_div['Daily_yield'] = (df_div['Yield']  / 100 + 1) ** (1 / days_year)
# Delete date and yield column of the dataframe
df_div = df_div.drop(['Date', 'Yield'], axis=1)

# Initialize the daily dividens yield column at historical data dataframe
df_sp500['Daily_div'] = 0
for year in range(2021, 1920, -1):
    # Change the daily dividens yield column corresponding with the yield of the same year
    daily_yield = df_div.loc[df_div['Year'] == year, 'Daily_yield'].values[0]
    df_sp500.loc[df_sp500['date'] < (year + 1) * 1e+4, 'Daily_div'] = daily_yield

# Calculate the relative increases of closing price adjusted for dividends yield
df_sp500['Diff_close_div'] = df_sp500['Diff_close'] * df_sp500['Daily_div']
# Calculate the cumulative increases of closing price adjusted for dividends yield
df_sp500['Cum_Diff_close_div'] = np.cumprod(df_sp500['Diff_close_div'])

# Save the historical dataframe as a .csv
df_sp500.to_csv('SP500.csv')
