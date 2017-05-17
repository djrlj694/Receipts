import XCTest

class ReceiptsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        
        app.navigationBars["Receipts"].buttons["Refresh"].tap()
        
        snapshot("01ReceiptLists")
        
        let cells = XCUIApplication().tables.cells
        let firstCell = cells.element(boundBy: 0)
        let staticTextOfFirstCell = firstCell.staticTexts.element(boundBy: 0)
        staticTextOfFirstCell.tap()
        
        snapshot("02ReceiptDetails")

        let detailNavigationBar = app.navigationBars["Detail"]
        detailNavigationBar.buttons["Edit"].tap()
        
        snapshot("02ReceiptEdit")
        
    }
    
}
