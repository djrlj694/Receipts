import UIKit

class ReceiptsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewReceiptFormViewControllerDelegate {

    var receipts: [Receipt] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSampleReceipts()
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
    
    func buildSampleReceipts() {
        for n in 1...100 {
            let newReceipt = Receipt(title: "Receipt Number \(n)", date: Date(), amount: NSDecimalNumber(value: n))
            receipts.append(newReceipt)
        }
    }
    
    func newReceiptFormViewControllerDidSave() {
        dismiss(animated: true, completion: nil)
    }
    
    func newReceiptFormViewControllerDidCancel() {
        dismiss(animated: true, completion: nil)
    }

}
