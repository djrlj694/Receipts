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
    
    func testAppendBehaviorWhenAlreadyPresent() {
        let storeURL = randomReceiptStoreURL()
        let store = ReceiptStore(fileURL: storeURL)
        
        let r1 = Receipt(title: UUID().uuidString, date: Date(), amount: NSDecimalNumber(string: "12.34"))
        store.addReceipt(r1)
        
        let r2 = Receipt(title: UUID().uuidString, date: Date(), amount: NSDecimalNumber(string: "12.34"))
        store.addReceipt(r2)
        
        let r3 = Receipt(title: UUID().uuidString, date: Date(), amount: NSDecimalNumber(string: "12.34"))
        store.addReceipt(r3)
        
        let indexOfR1Before = store.receipts.index(of: r1)
        store.addReceipt(r1)
        let indexOfR1After = store.receipts.index(of: r1)
        XCTAssertEqual(indexOfR1Before, indexOfR1After)
    }
    
    //Mark: - Private
    
    private func randomReceiptStoreURL() -> URL {
        let randomUUID = UUID().uuidString
        let testFileName = "\(randomUUID).receipts)"
        let storeURL = DeveloperSettings.receiptStoreFileURL(filename: testFileName)
        return storeURL
    }
    
}
