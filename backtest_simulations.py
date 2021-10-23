import pandas as pd
import numpy as np

df = pd.read_csv('simulations.csv')

initial_contrib = 2500
month_contrib = 350

# Mensual

total_amount = initial_contrib * df.iloc[len(df) - 1]
for i in range(1, int(len(df) / 30)):
    total_amount += month_contrib * df.iloc[len(df) - 1] / df.iloc[30 * i]

print('Monthly final amount: {:.2f}€'.format(np.mean(total_amount)))

total_amount.to_csv('amounts.csv', header=['Amounts'])

# Diario

daily_contrib = month_contrib / 30
total_amount = initial_contrib * df.iloc[len(df) - 1]
for i in range(1, len(df)):
    total_amount += daily_contrib * df.iloc[len(df) - 1] / df.iloc[i]

print('Monthly final amount: {:.2f}€'.format(np.mean(total_amount)))