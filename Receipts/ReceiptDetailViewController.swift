import UIKit

class ReceiptDetailViewController: UIViewController, NewReceiptFormViewControllerDelegate {
    
    var receiptStore: ReceiptStore!
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
            vc.receiptStore = receiptStore
        }
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let share = UIAlertAction(title: "Share", style: .default, handler:{ (action) in
            
            if let receipt = self.receipt {
                print("share on Slack")
                let session = URLSession.shared
                let url = URL(string: "https://hooks.slack.com/services/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")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let payload = [ "text" : receipt.slackDescription ]
                do {
                    let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
                    request.httpBody = payloadData
                    let postTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        
                        if let error = error, data == nil {
                            print("Got back an error from the server: \(error)")
                        }
                        
                        let httpResponse = response as! HTTPURLResponse
                        switch httpResponse.statusCode {
                        case 200...299:
                            print("successful request")
                            
                            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                            let alertVC = UIAlertController(title: "Receipt Posted!", message: nil, preferredStyle: .alert)
                            alertVC.addAction(ok)
                            self.present(alertVC, animated: true, completion: nil)
                            
                        case 300...399:
                            print("request should be rerouted")
                        case 400...499:
                            if let data = data, let response = String(data: data, encoding: .utf8) {
                                print("problem with the client/request: \(response)")
                            } else {
                                print("unknown problem with the client/request")
                            }
                        case 500...599:
                            print("problem with the server")
                        default:
                            print("unexpected server response")
                        }
                    })
                    postTask.resume()
                } catch (let error) {
                    print("Could not post to Slack: \(error)")
                }
                
            }
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let alertVC = UIAlertController(title: "Share on Slack?", message: "Sharing this receipt will post it's details on Slack.", preferredStyle: .alert)
        alertVC.addAction(cancel)
        alertVC.addAction(share)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - NewReceiptFormViewControllerDelegate
    
    func newReceiptFormViewControllerDidFinish(changedReceipts: [Receipt]) {
        guard changedReceipts.count > 0 else {
            dismiss(animated: true, completion: nil)
            return // there were no changes, user canceled edit
        }
        
        precondition(changedReceipts.count == 1, "We expect one changedReceipt, the one we passed in.")
        precondition(changedReceipts[0] == self.receipt!, "We expect to get back the same receipt we passed in.")
        
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
        
        dismiss(animated: true, completion: nil)
    }

}
