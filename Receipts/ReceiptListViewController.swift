import UIKit

class ReceiptListViewController: UIViewController, NewReceiptFormViewControllerDelegate {
    
    var receiptStore: ReceiptStore!
    private var receipts: [Receipt] {
        return receiptStore.receipts
    }
    
    var tableViewManager: ReceiptTableViewManager!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewManager = ReceiptTableViewManager(tableView: tableView, receiptStore: receiptStore)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewManager.deselectAndReloadCurrentTableViewSelection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let receipt = receipts[indexPath.row]
            let vc = segue.destination as! ReceiptDetailViewController
            vc.receipt = receipt
            vc.receiptStore = receiptStore
        } else if segue.identifier == "showNewForm" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! NewReceiptFormViewController
            vc.delegate = self
            vc.receiptStore = receiptStore
        }
    }
    
    @IBAction func syncReceipts(_ sender: UIBarButtonItem) {
        let remoteStore = ReceiptRemoteStore()
        let newReceipts = remoteStore.getNewRecieptsSinceLastSync()
        newReceipts.forEach { (receipt) in
            receiptStore.addReceipt(receipt)
        }
        tableView.reloadData()
    }
    
    //MARK: - NewReceiptFormViewControllerDelegate
    
    func newReceiptFormViewControllerDidFinish(changedReceipts: [Receipt]) {
        if changedReceipts.count > 0 {
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

}
