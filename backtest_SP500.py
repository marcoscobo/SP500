import pandas as pd
import numpy as np
from tabulate import tabulate
import matplotlib.pyplot as plt


### Backtesting Simulations

## Backtesting variables
years_backtest = 20
initial_contrib = 1500
month_contrib = 500

## Load simulations
simulations = pd.read_csv('simulations.csv')

## Calculate contributions
month_contribs, day_contribs = [0] * len(simulations), [0] * len(simulations)
for i in range(years_backtest * 12):
    month_contribs[21 * i] = month_contrib
month_contribs[0] = month_contribs[0] + initial_contrib
for i in range(len(simulations)):
    day_contribs[i] = month_contrib / 21
day_contribs[0] = day_contribs[0] + initial_contrib

## Get cumulatives profits
ncols = 10000
month_total_amounts, day_total_amounts = [0] * ncols, [0] * ncols
for col in range(ncols):
    returns = simulations.iloc[:,col].apply(lambda x: simulations.iloc[-1,col] / x).values
    month_total_amounts[col] = sum(np.array(returns) * np.array(month_contribs))
    day_total_amounts[col] = sum(np.array(returns) * np.array(day_contribs))

## Backtesting (monthly)
print('-' * 6, 'BACKTESTING', '-' * 7)
avg_amount = np.mean(month_total_amounts)
std_amount = np.std(month_total_amounts)
min_amount = np.min(month_total_amounts)
print(tabulate([['AVG Final amount:', '{:.2f}€'.format(avg_amount)],
                ['STD Final amount:', '{:.2f}€'.format(std_amount)],
                ['Min Final amount:', '{:.2f}€'.format(min_amount)],
                ['Contribution:', ' {:.2f}€'.format(sum(month_contribs))],
                ['AVG Profit:', ' {:.2f}€'.format(avg_amount - sum(month_contribs))]],
                tablefmt='plain', colalign=('left', 'right'), floatfmt=".4f"))
print('-' * 26, '\n')

plt.hist(month_total_amounts, bins=50, density=True, range=(0, 1.6e+6))
plt.show()

## Backtesting (daily)
print('-' * 6, 'BACKTESTING', '-' * 7)
avg_amount = np.mean(day_total_amounts)
std_amount = np.std(day_total_amounts)
min_amount = np.min(day_total_amounts)
print(tabulate([['AVG Final amount:', '{:.2f}€'.format(avg_amount)],
                ['STD Final amount:', '{:.2f}€'.format(std_amount)],
                ['Min Final amount:', '{:.2f}€'.format(min_amount)],
                ['Contribution:', ' {:.2f}€'.format(sum(month_contribs))],
                ['AVG Profit:', ' {:.2f}€'.format(avg_amount - sum(month_contribs))]],
                tablefmt='plain', colalign=('left', 'right'), floatfmt=".4f"))
print('-' * 26, '\n')

plt.hist(day_total_amounts, bins=50, density=True, range=(0, 1.6e+6))
plt.show()



### Backtesting SP500

## Load historical data
df = pd.read_csv('SP500.csv')
# Get backtesting period historical data
df = df[len(df) - (years_backtest * 252):].reset_index()
df['Cum_Diff_close_div'] = df['Cum_Diff_close_div'] / df['Cum_Diff_close_div'][0]

## Calculate historical annual rentability
rent = df['Cum_Diff_close_div'][len(df) - 1] ** (1 / years_backtest)
print('Historical annual rentability: {:.2f}%\n'.format((rent - 1) * 100))

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