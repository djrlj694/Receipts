import UIKit

class ReceiptTableViewManager: NSObject, UITableViewDataSource {
    
    let tableView: UITableView
    let receiptStore: ReceiptStore
    var receipts: [Receipt] {
        return receiptStore.receipts
    }
    
    /// Initializes a new Receipt TableView Manager.
    ///
    /// - Parameter tableView: the tableView which wants it's dataSource to be this manager instance.
    init(tableView: UITableView, receiptStore: ReceiptStore) {
        self.tableView = tableView
        self.receiptStore = receiptStore
        super.init()
        configureTableView()
    }
    
    
    /// This method will deselect any current table view selections while making sure to reload the previously selected cells as well.
    /// This is a particularly helpful thing when coming back to a tableView after a user had selected a row for possible editing.
    func deselectAndReloadCurrentTableViewSelection() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        let receipt = receipts[indexPath.row]
        cell.titleLabel.text = receipt.title
        let f1 = NumberFormatter()
        f1.numberStyle = .currency
        cell.amountLabel.text = f1.string(from: receipt.amount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedReceipt = receipts[indexPath.row]
            receiptStore.removeReceipt(selectedReceipt)
            if receiptStore.save() {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                print("Could not save receipt store")
                tableView.reloadData()
            }
        }
    }
    
    //MARK: - Private
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
    }

}
