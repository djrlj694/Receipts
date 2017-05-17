import XCTest
@testable import Receipts

class ReceiptStoreTests: XCTestCase {
    
    func testMakeANewStoreAndSaveASingleReceipt() {
        
        let storeURL = randomReceiptStoreURL()
        let store = ReceiptStore(fileURL: storeURL)
        let title = "Apple"
        let date = Date()
        let amount = NSDecimalNumber(string: "12.34")
        let testReceipt = Receipt(title: title, date: date, amount: amount)
        
        XCTAssertEqual(store.receipts.count, 0)
        store.addReceipt(testReceipt)
        XCTAssertEqual(store.receipts.count, 1)
        
        // save
        let success = store.save()
        XCTAssertTrue(success)
        
        // validate the save
        let newStore = ReceiptStore(fileURL: storeURL)
        XCTAssertEqual(newStore.receipts.count, 1)
        let savedReceipt = newStore.receipts.first!
        XCTAssertEqual(savedReceipt.title, title)
        XCTAssertEqual(savedReceipt.date, date)
        XCTAssertEqual(savedReceipt.amount, amount)
    }
    
    func testCanDeleteFromStore() {
        
        let storeURL = randomReceiptStoreURL()
        
        let store = ReceiptStore(fileURL: storeURL)
        let title = "Apple"
        let date = Date()
        let amount = NSDecimalNumber(string: "12.34")
        let testReceipt = Receipt(title: title, date: date, amount: amount)
        
        XCTAssertEqual(store.receipts.count, 0)
        store.addReceipt(testReceipt)
        XCTAssertEqual(store.receipts.count, 1)
        
        store.removeReceipt(testReceipt)
        XCTAssertEqual(store.receipts.count, 0)
    }
    
    //Mark: - Private
    
    private func randomReceiptStoreURL() -> URL {
        let randomUUID = UUID().uuidString
        let testFileName = "\(randomUUID).receipts)"
        let storeURL = DeveloperSettings.receiptStoreFileURL(filename: testFileName)
        return storeURL
    }
    
}
