import UIKit

protocol NewReceiptFormViewControllerDelegate: class {
    func newReceiptFormViewControllerDidSaveReceipt(receipt: Receipt)
    func newReceiptFormViewControllerDidCancel()
}

class NewReceiptFormViewController: UIViewController, DatePickerInputViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: NewReceiptFormViewControllerDelegate?
    var photo: UIImage?
    var editingReceipt: Receipt?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var addPhotoRow: UIStackView!
    @IBOutlet var removePhotoRow: UIStackView!
    @IBOutlet var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let datePickerInputView = DatePickerInputView.createView()
        datePickerInputView.datePickerMode = .dateAndTime
        datePickerInputView.delegate = self
        dateTextField.inputView = datePickerInputView
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        view.addGestureRecognizer(tapGR)
        
        if let receipt = editingReceipt {
            titleTextField.text = receipt.title
            let f1 = NumberFormatter()
            f1.numberStyle = .currency
            amountTextField.text = f1.string(from: receipt.amount)
            let f2 = DateFormatter()
            f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
            dateTextField.text = f2.string(from: receipt.date)
            photo = receipt.photo
        }
        
        updateFormUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        guard view.endEditing(false) else {
            return
        }
        delegate?.newReceiptFormViewControllerDidCancel()
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        guard view.endEditing(false) else {
            return
        }
        
        // validate title
        if let potentialTitle = titleTextField.text {
            if potentialTitle.characters.count < 3 {
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alertVC = UIAlertController(title: "Invalid Title", message: "Title requires more than 3 characters.", preferredStyle: .alert)
                alertVC.addAction(ok)
                present(alertVC, animated: true, completion: nil)
                return
            }
        } else {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertVC = UIAlertController(title: "Invalid Title", message: "Title required.", preferredStyle: .alert)
            alertVC.addAction(ok)
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        // validate amount
        if amountTextField.text == nil || amountTextField.text!.isEmpty  {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertVC = UIAlertController(title: "Invalid Amount", message: "Amount required.", preferredStyle: .alert)
            alertVC.addAction(ok)
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        // validate date
        if dateTextField.text == nil || dateTextField.text!.isEmpty  {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertVC = UIAlertController(title: "Invalid Date", message: "Date required.", preferredStyle: .alert)
            alertVC.addAction(ok)
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        if let editingReceipt = editingReceipt {
            
            editingReceipt.title = titleTextField.text!
            
            let f1 = NumberFormatter()
            f1.numberStyle = .currency
            let amount = f1.number(from: amountTextField.text!)!.decimalValue as NSDecimalNumber
            editingReceipt.amount = amount
            
            if let dateText = dateTextField.text {
                let f2 = DateFormatter()
                f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                editingReceipt.date = f2.date(from: dateText)!
            }
            
            editingReceipt.photo = photo
            
            delegate?.newReceiptFormViewControllerDidSaveReceipt(receipt: editingReceipt)

        } else {
            
            let title = titleTextField.text!
            let amount = NSDecimalNumber(string: amountTextField.text)
            
            let f2 = DateFormatter()
            f2.dateFormat = "EEEE, MMM d, yyyy h:mm a"
            let date = f2.date(from: dateTextField.text!)!
            
            let newReceipt = Receipt(title: title, date: date, amount: amount, photo: photo)
            delegate?.newReceiptFormViewControllerDidSaveReceipt(receipt: newReceipt)

        }
        
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
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func removePhotoAction(_ sender: UIButton) {
        photo = nil
        updateFormUI()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo = image
        }
        updateFormUI()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateFormUI() {
        
        if photo != nil {
            addPhotoRow.isHidden = true
            removePhotoRow.isHidden = false
        } else {
            addPhotoRow.isHidden = false
            removePhotoRow.isHidden = true
        }
        photoImageView.image = photo
        
    }
    
}
