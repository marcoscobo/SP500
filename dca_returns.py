import yfinance as yf
import pandas as pd
from datetime import datetime, timedelta

initial_value = 0
monthly_contrib = 300
contribution_day_of_week = 0 # (0 = Lunes, 1 = Martes, ..., 4 = Viernes)
years = 30
ticker = "^GSPC"

sp500 = yf.Ticker(ticker=ticker)
end_date = datetime.today()
start_date = end_date - timedelta(days=years*365)
data = sp500.history(start=start_date, end=end_date)
df = pd.DataFrame(data["Close"])
df['Yield'] = df['Close'] / df['Close'].iloc[0]
df['Monthly'], df['Weekly'], df['Daily'] = 0.0, 0.0, 0.0

def calculate_monthly_contributions(df, initial_value, monthly_contrib):
    total_value = initial_value
    for i in range(len(df)):
        if df.index[i].day % 21 == 0:
            total_value += monthly_contrib
        df.at[df.index[i], 'Monthly'] = total_value * (df['Yield'].iloc[i])
    return df

def calculate_weekly_contributions(df, initial_value, monthly_contrib, contribution_day_of_week):
    total_value = initial_value
    for i in range(len(df)):
        if df.index[i].weekday() == contribution_day_of_week:
            total_value += monthly_contrib / (21 / 5)
        df.at[df.index[i], 'Weekly'] = total_value * (df['Yield'].iloc[i])
    return df

def calculate_daily_contributions(df, initial_value, monthly_contrib):
    total_value = initial_value
    for i in range(len(df)):
        total_value += monthly_contrib / 21
        df.at[df.index[i], 'Daily'] = total_value * (df['Yield'].iloc[i])
    return df

def compare_weekly_contributions(df, initial_value, monthly_contrib):
    results = {}
    for day in range(5):
        df_temp = df.copy()
        df_temp = calculate_weekly_contributions(df_temp, initial_value, monthly_contrib, day)
        results[day] = df_temp['Weekly'].iloc[-1]
    return results

df = calculate_monthly_contributions(df, initial_value, monthly_contrib)
df = calculate_weekly_contributions(df, initial_value, monthly_contrib, contribution_day_of_week)
df = calculate_daily_contributions(df, initial_value, monthly_contrib)

# Resumen de resultados
print("Resumen de resultados:")
print("Valor final con contribuciones mensuales: ${:.2f}".format(df['Monthly'].iloc[-1]))
print("Valor final con contribuciones semanales: ${:.2f}".format(df['Weekly'].iloc[-1]))
print("Valor final con contribuciones diarias: ${:.2f}".format(df['Daily'].iloc[-1]))

# Comparativa de días de la semana para aportaciones semanales
weekly_comparison = compare_weekly_contributions(df, initial_value, monthly_contrib)
days_of_week = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]
print("\nComparativa de días de la semana para aportaciones semanales:")
for day, value in weekly_comparison.items():
    print(f"{days_of_week[day]}: ${value:.2f}")
best_day = max(weekly_comparison, key=weekly_comparison.get)
print(f"\nEl mejor día para realizar las aportaciones semanales es: {days_of_week[best_day]} con un valor de ${weekly_comparison[best_day]:.2f}")

# # Calcular diferencias
# df['Diff_Monthly_Weekly'] = df['Monthly'] - df['Weekly']
# df['Diff_Monthly_Daily'] = df['Monthly'] - df['Daily']
# df['Diff_Weekly_Daily'] = df['Weekly'] - df['Daily']

# # Resumen de diferencias:
# print("Resumen de diferencias:")
# print("Diferencia entre contribuciones mensuales y semanales: ${:.2f}".format(df['Diff_Monthly_Weekly'].iloc[-1]))
# print("Diferencia entre contribuciones mensuales y diarias: ${:.2f}".format(df['Diff_Monthly_Daily'].iloc[-1]))
# print("Diferencia entre contribuciones semanales y diarias: ${:.2f}".format(df['Diff_Weekly_Daily'].iloc[-1]))