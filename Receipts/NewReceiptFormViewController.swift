import UIKit

protocol NewReceiptFormViewControllerDelegate: class {
    func newReceiptFormViewControllerDidSave()
    func newReceiptFormViewControllerDidCancel()
}

class NewReceiptFormViewController: UIViewController, DatePickerInputViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: NewReceiptFormViewControllerDelegate?
    var photo: UIImage?
    
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
        
        updateFormUI()
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
