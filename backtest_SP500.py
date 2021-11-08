import pandas as pd
from tabulate import tabulate

## Backtesting variables
years_backtest = 25
initial_contrib = 2500
month_contrib = 350

## Load historical data
df = pd.read_csv('SP500.csv')
# Get backtesting period historical data
df = df[len(df) - (years_backtest * 252):].reset_index()
df['Cum_Diff_close_div'] = df['Cum_Diff_close_div'] / df['Cum_Diff_close_div'][0]

## Calculate historical anual rentability
rent = df['Cum_Diff_close_div'][len(df) - 1] ** (1 / years_backtest)
print('Historical anual rentability: {:.2f}%\n'.format((rent - 1) * 100))

## Backtesting (monthly)
# Initialize the total amount with the increment of initial contribution
total_amount = initial_contrib * df['Cum_Diff_close_div'][len(df) - 1]
for i in range(1, int(len(df) / 21)):
    # Add the monthly contribution increased by the final return to the total amount
    total_amount += month_contrib * df['Cum_Diff_close_div'][len(df) - 1] / df['Cum_Diff_close_div'][21 * i]
# Calculate the total contribution
total_contrib = initial_contrib + month_contrib * 12 * years_backtest
# Calculate the profit
profit = total_amount - total_contrib

# Print the results
print('-' * 6, 'BACKTESTING', '-' * 7)
print(tabulate([['Final amount:', '{:.2f}€'.format(total_amount)],
                ['Contribution:', ' {:.2f}€'.format(total_contrib)],
                ['Profit:', ' {:.2f}€'.format(profit)]],
                tablefmt='plain', colalign=('left', 'right'), floatfmt=".4f"))
print('-' * 26, '\n')

## Backtesting (daily)
# Get the daily contribution instead of monthly contribution (a month has approximately 21 market opening days)
daily_contrib = month_contrib / 21
# Initialize the total amount with the increment of initial contribution
total_amount = initial_contrib * df['Cum_Diff_close_div'][len(df) - 1]
for i in range(1, len(df)):
    # Add the monthly contribution increased by the final return to the total amount
    total_amount += daily_contrib * df['Cum_Diff_close_div'][len(df) - 1] / df['Cum_Diff_close_div'][i]
# Calculate the total contribution
total_contrib = initial_contrib + month_contrib * 12 * years_backtest
# Calculate the profit
profit = total_amount - total_contrib

# Print the results
print('-' * 6, 'BACKTESTING', '-' * 7)
print(tabulate([['Final amount:', '{:.2f}€'.format(total_amount)],
                ['Contribution:', ' {:.2f}€'.format(total_contrib)],
                ['Profit:', ' {:.2f}€'.format(profit)]],
                tablefmt='plain', colalign=('left', 'right'), floatfmt=".4f"))
print('-' * 26, '\n')