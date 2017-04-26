import Foundation

class Receipt: NSObject {
    let title: String
    let date: Date
    let amount: Int
    
    init(title: String, date: Date, amount: Int) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
