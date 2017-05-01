import Foundation

class Receipt: NSObject {
    let title: String
    let date: Date
    let amount: NSDecimalNumber
    
    init(title: String, date: Date, amount: NSDecimalNumber) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
