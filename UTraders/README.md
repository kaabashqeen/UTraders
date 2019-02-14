# UTraders_FinalProject (Kaab Ashqeen and CJ Izzo)

## Introduction
> UTraders is a paper trading application. It utilizes the Stock Market API, Intrinio, to search and display different companies/stocks for trading. With UTraders, you are given a fictional amount of money that you can use to buy and sell shares of different companies over time. Now go ahead and invest to test out your strategies!

## Basic Requirements
> At least 3 Views: Portfolio View, Search View, Settings View, Asset View; Core Data: Portfolio information (stocks invested, portfolio value, investment value) are stored in core data; Core Animation/ Core Graphics: Graphs in Asset View and Portfolio View are drawn with Core Graphics; Additional framework(Core Gesture): Swipe gestures both left and right change the view on the portfolio graph; Networking: Intrinio APIs for searching and retrieving Stock Data 

## Features (Extra Credit Features are Marked with *Ω*)
### Portfolio View
- A model of your portfolio over time is shown on the graph of the main view, showing how your portfolio will have trended for the past month *Ω* (this was a douzy to implement: we had to create a custom algorithm, handler, and View Display class to store and structure this data over time AND also graph with core graphics)
- Swiping the graph flips the view to see a discrete value of your total portfolio. 
- Clicking the upper left hand icon on sends you to the Settings View
- Clicking a cell (if there is one) sends you to the Asset View
- This view updates every 7 seconds with the current prices *Ω* (This also was a really complicated task to handle. What made this really cool is how you can actively see your current portfolio and stocks, and how they are performing in real time. To do so, we had to figure out how different delgate calls are handled (such as viewDidLoad occurs first, then any segue action or viewWillAppear), how threading works with tasks in our code and etc.)

### Search View
- Searching queries Intrinio's vast Company Library on any text change to show companies that have their name containing the text query *Ω* (this was another case that took into account different function task execution order. Displaying information correctly with a constantly updating list for the tableView was a huge challenge without delving into how tableView's and updates work on a low level.)
- Clicking a stock sends you to the Asset View

### Settings View
- You can view your current amount invested in stocks, and current portfolio value here
- Clicking the add funds button, allows you to add more money to your portfolio for investing

### Asset View
- You can see a graph of the stock's value over the last month *Ω* (same as above with the portfolio graph)
- You can also see the the current value, open, high, low and average, and the amount of shares you potentially have invested in the company. This information is queried using Intrino's Price API. 
- Clicking the buy button, returns you to the portfolio view where you can see that the amount of shares you bought at the current price have been stored into Core Data (like everything else you buy or sell).
- Clicking the sell button, allows you to sell shares of the stock (if you have bought it before) at the current price. This updates your portfolio value to increase by the amount you gained or lost. This also updates your portfolio to not have the shares you sold anymore.

All of the colors are taken from UT's official color hexcodes. 
We also have custom fonts and images implemented! 

# Test
1. Search for a stock (Apple for ease)
2. Buy a few shares of the stock
3. Wait for portfolio to update (7 seconds)
4. Swipe on graph view to see current value
5. Click on stock in portfolio view, and sell a few shares of the stock
6. Click on settings
7. Add some funds to portfolio Value
8. Check portfolio value by swiping on portfolio view
9. Buy few shares of a different stock (Facebook if you want)
10. Wait for portfolio to update
11. See the updated graph of portfolio value over time is a combination of your current stocks


