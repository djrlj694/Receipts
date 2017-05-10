import UIKit

class Receipt: NSObject, NSCoding {
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
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(photo, forKey: "photo")
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
            let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let amount = aDecoder.decodeObject(forKey: "amount") as? NSDecimalNumber,
            let photo = aDecoder.decodeObject(forKey: "photo") as? UIImage?
            else { return nil }
        
        self.init( title: title, date: date, amount: amount, photo: photo)
    }
}
