import UIKit

class ReceiptsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var receipts: [Receipt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSampleReceipts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        let receipt = receipts[indexPath.row]
        cell.titleLabel.text = receipt.title
        cell.amountLabel.text = "$\(receipt.amount)"
        return cell
    }
    
    func buildSampleReceipts() {
        for n in 1...100 {
            let newReceipt = Receipt(title: "Receipt Number \(n)", date: Date(), amount: n)
            receipts.append(newReceipt)
        }
    }

}
