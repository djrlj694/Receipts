import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var receiptStore: ReceiptStore?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureInitialViewController()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let receiptStore = receiptStore {
            if !receiptStore.save() {
                print("Could not save store to disk")
            }
        }
    }
    
    //MARK: - Private
    
    private func configureInitialViewController() {
        guard let navController = window?.rootViewController as? UINavigationController else {
            assertionFailure("Expect the storyboard to launch with a root navigation controller")
            return
        }
        
        guard let listVC = navController.topViewController as? ReceiptListViewController else {
            assertionFailure("Expected the navigation controller to launch with a root ReceiptsListViewController instance")
            return
        }
        
        listVC.receiptStore = ReceiptStore(fileURL: DeveloperSettings.receiptStoreFileURL())
    }
    
}
