import XCTest
@testable import Receipts

class ReceiptListViewControllerTests: XCTestCase {
    
    func testSyncActionAddsRowsToTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "ReceiptsListViewController") as! ReceiptsListViewController
        let storeURL = DeveloperSettings.randomReceiptStoreURL()
        let store = ReceiptStore(fileURL: storeURL)
        listVC.receiptStore = store
        listVC.loadViewIfNeeded()
        
        XCTAssertEqual(listVC.tableView.numberOfRows(inSection: 0), 0)
        listVC.syncReceipts(UIBarButtonItem())
        XCTAssertEqual(listVC.tableView.numberOfRows(inSection: 0), 5)
    }
    
}
