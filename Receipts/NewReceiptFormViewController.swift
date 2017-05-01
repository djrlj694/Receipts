import UIKit

protocol NewReceiptFormViewControllerDelegate: class {
    func newReceiptFormViewControllerDidSave()
    func newReceiptFormViewControllerDidCancel()
}

class NewReceiptFormViewController: UIViewController {

    weak var delegate: NewReceiptFormViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        delegate?.newReceiptFormViewControllerDidCancel()
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        delegate?.newReceiptFormViewControllerDidSave()
    }
    
}
