# SQL Exercises

## Window Functions

https://www.codecademy.com/resources/docs/sql/window-functions
https://www.datacamp.com/cheat-sheet/sql-window-functions-cheat-sheet

### Ranking Functions

**ROW_NUMBER()** is useful for pagination (getting rows 1-10, 11-20, etc.), finding the first/last occurrence of something, or when you need unique sequential numbers.

**RANK()** is perfect for competition or sports rankings where multiple participants can tie. For example, in a race, if two runners finish in 20.5 seconds, they both get 1st place. The next runner finishing in 20.7 seconds gets 3rd place (not 2nd). This matches how real-world competitions handle ties.

**DENSE_RANK()** is perfect for grading systems or classification tiers. For example, in a class grading system, if three students score 95%, they all get rank 1. If two students score 92%, they get rank 2 (not rank 4). This matches how real-world grading systems handle ties.


### Window Frames

**Moving Averages**: Perfect for smoothing out data fluctuations. For example, calculating a 7-day moving average of sales to spot trends while reducing daily noise. This is commonly used in stock market analysis and sales forecasting.

**Running Totals**: Great for financial reports where you need to show how values accumulate over time. For instance, tracking cumulative revenue throughout a fiscal year or maintaining a running balance in a checkbook.

**Time-Based Analysis**: Using RANGE with date intervals is perfect for comparing current period with previous period (like month-over-month growth) and calculating rolling metrics (like "last 30 days" totals) or finding trends in time-series data.

**Sliding Window Calculations**: Useful when you need to look at a fixed number of rows before and after each row. For example, finding unusual values by comparing each row with its neighbors or calculating percentage changes between consecutive periods.

