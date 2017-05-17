import Foundation

class ReceiptStore {
    
    let fileURL: URL
    private(set) var receipts: [Receipt] = []
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        loadReceiptsFromDisk()
    }
    
    /// Receives a receipt and appends it to our internal collection of receipts.
    /// Note: You must call save() for any perseistance to occur.
    ///
    /// - Parameter receipt: the receipt to be added to the store
    public func addReceipt(_ receipt: Receipt) {
        receipts.append(receipt)
    }
    
    /// Serializes the current receipts to disk.
    ///
    /// - Returns: a Bool to signal if the save was successful
    public func save() -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(receipts, toFile: fileURL.path)
        if !success {
            print("Could not save data.")
        }
        return success
    }
    
    //MARK: - Private
    
    @discardableResult
    private func loadReceiptsFromDisk() -> Bool {
        if let unarchivedReceipts = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [Receipt] {
            receipts = unarchivedReceipts
            return true
        } else {
            return false
        }
    }
    
}
