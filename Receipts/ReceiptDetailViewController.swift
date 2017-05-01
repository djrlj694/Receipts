import UIKit

class ReceiptDetailViewController: UIViewController {
    
    var receipt: Receipt?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let receipt = receipt {
            titleLabel.text = receipt.title
            let f1 = NumberFormatter()
            f1.numberStyle = .currency
            amountLabel.text = f1.string(from: receipt.amount)
            let f2 = DateFormatter()
            f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
            dateLabel.text = f2.string(from: receipt.date)
        }
    }

    
    
}
