import UIKit

protocol DatePickerInputViewDelegate: class {
    func datePickerValueDidChange(newValue: Date)
    func datePickerInputViewDidFinish()
}

class DatePickerInputView: UIView {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerInputViewDelegate?
    var datePickerMode: UIDatePickerMode = .date {
        didSet {
            if datePicker != nil {
                datePicker.datePickerMode = datePickerMode
            }
        }
    }
    
    static func createView() -> DatePickerInputView {
        let nib = UINib(nibName: "DatePickerInputView", bundle: nil)
        let nibContents = nib.instantiate(withOwner: nil, options: nil)
        assert(nibContents.count == 1, "\(nib) should hold only a single view, but found \(nibContents.count) items: \(nibContents)")
        return nibContents.first as! DatePickerInputView
    }
    
    override func awakeFromNib() {
        datePicker.datePickerMode = datePickerMode
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        delegate?.datePickerInputViewDidFinish()
    }
    
    @IBAction func datePickerValueDidChange(_ sender: UIDatePicker) {
        delegate?.datePickerValueDidChange(newValue: datePicker.date)
    }
    
}
