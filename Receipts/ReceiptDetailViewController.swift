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
            amountLabel.text = receipt.amount.description
            dateLabel.text = receipt.date.description
        }
    }

    
    
}
