# Why SP500 is better to store value than your bank
This repository stores the code used in writing the article https://marcoscobocarrillo.medium.com/why-sp500-is-better-to-store-value-than-your-bank-part-i-697380ab8649. In it we simulate the future behavior of the SP500 stock index over a certain period of time to answer questions such as, what is the probability of ending up losing money in a fund indexed to the SP500 in a period of, for example, 20 years?, or, what is the probability of obtaining an average annual return of more than 5% per year?...

## Data used:

A large amount of historical data on the SP500 has been extracted from the open repository provided by Yahoo finance, as well as from the website https://www.multpl.com/s-p-500-dividend-yield/table/by-year.

## Libraries used:

In this article we will use the programming languages Python (version 3.8) and R (version 3.6.3), as well as different libraries, among which the following stand out:

- NumPy
- Pandas
- Pandas-datareader
- Datetime
- Parallel (R)

For the installation of all the libraries used, we recommend installing the requirements.txt file by typing the following command into the shell:

```
pip install -r requirements.txt
```
