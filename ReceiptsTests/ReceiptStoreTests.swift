import XCTest
@testable import Receipts

class ReceiptStoreTests: XCTestCase {
    
    func testMakeANewStoreAndSaveASingleReceipt() {
        
        // FIXME: Feel like this knowledge is better grouped with new class
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let randomUUID = UUID().uuidString
        let testFileName = "\(randomUUID).receipts)"
        let storeURL = documentsURL.appendingPathComponent(testFileName)
        
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
    
}
