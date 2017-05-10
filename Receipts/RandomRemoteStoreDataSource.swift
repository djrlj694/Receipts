import Foundation

class RandomRemoteStoreDataSource: ReceiptRemoteStoreDataSource {
    
    let possibleTitles = ["Parking", "Lunch", "Coffee", "Newspaper", "Parking Ticket"]
    
    // genetaes a JSON response with 5 random receipt descriptions
    func getNewRecieptsSinceLastSync() -> Data? {
        
        var response: String = ""
        
        for _ in 1...5 {
            
            let randomTitleIndex = Int(arc4random_uniform(UInt32(possibleTitles.count)))
            let title = possibleTitles[randomTitleIndex]
            
            let date = Date.randomWithinDaysBeforeToday(10)
            
            let amountDollars = Int.random(0, 99)
            let amountCents = Int.random(0, 99)
            let amount = "\(amountDollars).\(amountCents)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            if !response.isEmpty {
                response.append(",")
            }
            response.append("{\"title\" : \"\(title)\", \"date\" : \"\(dateFormatter.string(from: date))\", \"amount\" : \"\(amount)\"}")
            
        }
        
        if !response.isEmpty {
            return "[\(response)]".data(using: .utf8)
        } else {
            return nil
        }
        
    }
    
}

// https://github.com/thellimist/SwiftRandom/blob/master/SwiftRandom/Randoms.swift
public extension Date {
    /// SwiftRandom extension
    public static func randomWithinDaysBeforeToday(_ days: Int) -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(59))
        let r4 = arc4random_uniform(UInt32(59))
        
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = gregorian.date(byAdding: offsetComponents, to: today) else {
            print("randoming failed")
            return today
        }
        return rndDate1
    }
    
    /// SwiftRandom extension
    public static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
    
}

public extension Int {
    /// SwiftRandom extension
    public static func random(_ range: ClosedRange<Int>) -> Int {
        return random(range.lowerBound, range.upperBound)
    }
    /// SwiftRandom extension
    public static func random(_ lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
