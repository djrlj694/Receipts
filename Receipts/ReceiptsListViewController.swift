import UIKit

class ReceiptsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewReceiptFormViewControllerDelegate {

    let remoteStore = ReceiptRemoteStore()
    var receipts: [Receipt] = []
    var saveNotificationObserver: NSObjectProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let storeURL = documentsURL.appendingPathComponent("db.receipts")
        if let unarchivedReceipts = NSKeyedUnarchiver.unarchiveObject(withFile: storeURL.path) as? [Receipt] {
            receipts = unarchivedReceipts
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiptsListViewController.save), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
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
        } else if segue.identifier == "showNewForm" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! NewReceiptFormViewController
            vc.delegate = self
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
    
    func newReceiptFormViewControllerDidSaveReceipt(receipt: Receipt) {
        
        if !receipts.contains(receipt) {
            receipts.append(receipt)
        }
        tableView.reloadData()
        
        save()
        dismiss(animated: true, completion: nil)
    }
    
    func newReceiptFormViewControllerDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func syncReceipts(_ sender: UIBarButtonItem) {
        let newReceipts = remoteStore.getNewRecieptsSinceLastSync()
        receipts.append(contentsOf: newReceipts)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            receipts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func save() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let storeURL = documentsURL.appendingPathComponent("db.receipts")
        let success = NSKeyedArchiver.archiveRootObject(receipts, toFile: storeURL.path)
        if !success {
            print("Could not save data.")
        }
    }

}
