import UIKit

class Receipt: NSObject {
    var title: String
    var date: Date
    var amount: NSDecimalNumber
    var photo: UIImage?
    
    init(title: String, date: Date, amount: NSDecimalNumber, photo: UIImage? = nil) {
        self.title = title
        self.date = date
        self.amount = amount
        self.photo = photo
    }
}
