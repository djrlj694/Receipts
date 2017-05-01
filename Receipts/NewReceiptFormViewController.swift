import UIKit

protocol NewReceiptFormViewControllerDelegate: class {
    func newReceiptFormViewControllerDidSave()
    func newReceiptFormViewControllerDidCancel()
}

class NewReceiptFormViewController: UIViewController, DatePickerInputViewDelegate, UITextFieldDelegate {

    weak var delegate: NewReceiptFormViewControllerDelegate?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let datePickerInputView = DatePickerInputView.createView()
        datePickerInputView.datePickerMode = .dateAndTime
        datePickerInputView.delegate = self
        dateTextField.inputView = datePickerInputView
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        view.addGestureRecognizer(tapGR)
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
    
    func updateDateTextFieldFromPicker() {
        print("updateDateTextFieldFromPicker")
    }
    
    func datePickerValueDidChange(newValue: Date) {
        let f2 = DateFormatter()
        f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        dateTextField.text = f2.string(from: newValue)
    }
    
    func datePickerInputViewDidFinish() {
        view.endEditing(false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        return true
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
}
