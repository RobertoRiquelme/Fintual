How to run:

    Open Fintual.playground in Xcode, and run.

Notes:

	1.	The price(at:) method returns an optional Double because a price may not exist for a given date.
	2.	The profit(from:to:) method calculates the portfolio’s value at the start and end dates and returns the difference.
	3.	The annualizedReturn(from:to:) method calculates the annualized return based on the total return and the duration in years.