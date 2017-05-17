import XCTest
@testable import Receipts

class NewReceiptFormViewControllerTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "NewReceiptFormViewControllerNavigationController") as! UINavigationController
        let vc = navController.topViewController as! NewReceiptFormViewController
        
        let testImage = UIImage(named: "sample-receipt.jpg")
        let testReceipt = Receipt(title: "Testing", date: Date.distantPast, amount: NSDecimalNumber(string: "12.34"), photo: testImage)
        vc.editingReceipt = testReceipt
        
        FBSnapshotVerifyView(vc.view)
    }
    
}
