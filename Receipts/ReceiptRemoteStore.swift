import UIKit

protocol ReceiptRemoteStoreDataSource {
    func getNewRecieptsSinceLastSync() -> Data?
}

/// A fake store that emulates what a remote store interface might feel like.
/// For the purposes of this refactor project, a chance to play around with JSON.
class ReceiptRemoteStore {
    
    let dataSource: ReceiptRemoteStoreDataSource = RandomRemoteStoreDataSource()
    
    /// getNewRecieptsSinceLastSync - Generates and returns 5 new random receipts.
    func getNewRecieptsSinceLastSync() -> [Receipt] {
        
        var newReceipts = [Receipt]()
        
        if let jsonData = dataSource.getNewRecieptsSinceLastSync() {
            let json: [[String:Any]] = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String:Any]]
            for item in json {
                let title = item["title"] as! String
                
                let amountString = item["amount"] as! String
                let amount = NSDecimalNumber(string: amountString)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let dateString = item["date"] as! String
                let date = dateFormatter.date(from: dateString)!
                
                // We're going to pretend that the JSON source gave us a URL to a photo and we downloaded it
                // but for now, let's just use a sample image
                // NOTE: We this Data dance to avoid native caching systems of UIImage
                // The idea here is to simulate different images, so even though we are using the same source file
                // we want to feel like these are all different images.
                let resourceURL = Bundle.main.resourceURL
                let sampleReceiptURL = resourceURL!.appendingPathComponent("sample-receipt.jpg")
                let imageData = try! Data(contentsOf: sampleReceiptURL)
                let receiptImage = UIImage(data: imageData)
                
                let newReceipt = Receipt(title: title, date: date, amount: amount, photo: receiptImage)
                newReceipts.append(newReceipt)
            }
        }
        
        return newReceipts
    }
    
}
