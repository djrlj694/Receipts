import Foundation

struct DeveloperSettings {
    
    static var defaultReceiptStoreFilename: String {
        return "db.receipts"
    }
    
    static func receiptStoreFileURL(filename: String = defaultReceiptStoreFilename) -> URL {
        let storeURL = userDocumentsDirectoryURL.appendingPathComponent(filename)
        return storeURL
    }
    
    private static var userDocumentsDirectoryURL: URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath)
        return documentsURL
    }
    
}
