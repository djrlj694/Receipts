import UIKit

class ReceiptsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewReceiptFormViewControllerDelegate {
    
    var receiptStore: ReceiptStore!
    var receipts: [Receipt] {
        return receiptStore.receipts
    }
    
    let remoteStore = ReceiptRemoteStore()
    var saveNotificationObserver: NSObjectProtocol?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func syncReceipts(_ sender: UIBarButtonItem) {
        let newReceipts = remoteStore.getNewRecieptsSinceLastSync()
        newReceipts.forEach { (receipt) in
            receiptStore.addReceipt(receipt)
        }
        tableView.reloadData()
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
    
    //MARK: - NewReceiptFormViewControllerDelegate
    
    func newReceiptFormViewControllerDidFinish(changedReceipts: [Receipt]) {
        if changedReceipts.count > 0 {
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

}
