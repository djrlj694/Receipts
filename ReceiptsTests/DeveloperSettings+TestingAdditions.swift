import Foundation
@testable import Receipts

extension DeveloperSettings {
    
    static func randomReceiptStoreURL() -> URL {
        let randomUUID = UUID().uuidString
        let testFileName = "\(randomUUID).receipts)"
        let storeURL = DeveloperSettings.receiptStoreFileURL(filename: testFileName)
        return storeURL
    }
    
}
