import UIKit

class ReceiptDetailViewController: UIViewController, NewReceiptFormViewControllerDelegate {
    
    var receipt: Receipt?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
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
            imageView.image = receipt.photo
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditForm" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! NewReceiptFormViewController
            vc.delegate = self
            vc.editingReceipt = receipt
        }
    }
    
    func newReceiptFormViewControllerDidSaveReceipt(receipt: Receipt) {
        
        precondition(receipt == self.receipt!, "We should only get back the same receipt we passed in.")
        
        if let receipt = self.receipt {
            titleLabel.text = receipt.title
            let f1 = NumberFormatter()
            f1.numberStyle = .currency
            amountLabel.text = f1.string(from: receipt.amount)
            let f2 = DateFormatter()
            f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
            dateLabel.text = f2.string(from: receipt.date)
            imageView.image = receipt.photo
        }
        
        if view.endEditing(false) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func newReceiptFormViewControllerDidCancel() {
        if view.endEditing(false) {
            dismiss(animated: true, completion: nil)
        }
    }

}
