import Foundation

class Stock: Hashable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(name)
    }
    
    let name: String
    private var priceHistory: [Date: Double]  // A dictionary mapping dates to prices
    
    init(name: String, priceHistory: [Date: Double]) {
        self.name = name
        self.priceHistory = priceHistory
    }
    
    func price(at date: Date) -> Double? {
        return priceHistory[date]
    }
}

class Portfolio {
    private var stocks: [Stock: Int]  // Stock and the number of shares owned
    
    init(stocks: [Stock: Int]) {
        self.stocks = stocks
    }
    
    func profit(from startDate: Date, to endDate: Date) -> Double? {
        var startValue: Double = 0
        var endValue: Double = 0
        
        for (stock, shares) in stocks {
            guard
                let startPrice = stock.price(at: startDate),
                let endPrice = stock.price(at: endDate)
            else {
                return nil  // Cannot calculate profit if any price is missing
            }
            startValue += startPrice * Double(shares)
            endValue += endPrice * Double(shares)
        }
        
        return endValue - startValue
    }
    
    func annualizedReturn(from startDate: Date, to endDate: Date) -> Double? {
        guard let profitValue = profit(from: startDate, to: endDate) else {
            return nil
        }
        
        var startValue: Double = 0
        
        for (stock, shares) in stocks {
            if let startPrice = stock.price(at: startDate) {
                startValue += startPrice * Double(shares)
            } else {
                return nil
            }
        }
        
        let totalReturn = profitValue / startValue
        let timeInterval = endDate.timeIntervalSince(startDate)
        let years = timeInterval / (365 * 24 * 60 * 60)
        
        return pow(1 + totalReturn, 1 / years) - 1
    }
}


let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"

let startDate = dateFormatter.date(from: "2023-01-01")!
let endDate = dateFormatter.date(from: "2023-12-31")!

let apple = Stock(name: "Apple", priceHistory: [
    dateFormatter.date(from: "2023-01-01")!: 150.0,
    dateFormatter.date(from: "2023-12-31")!: 180.0
])

let google = Stock(name: "Google", priceHistory: [
    dateFormatter.date(from: "2023-01-01")!: 2800.0,
    dateFormatter.date(from: "2023-12-31")!: 3000.0
])

let portfolio = Portfolio(stocks: [
    apple: 10,
    google: 5
])

if let profit = portfolio.profit(from: startDate, to: endDate) {
    print("Profit: \(profit)")
}

if let annualizedReturn = portfolio.annualizedReturn(from: startDate, to: endDate) {
    print("Annualized Return: \(annualizedReturn * 100)%")
}
