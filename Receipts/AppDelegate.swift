//
//  AppDelegate.swift
//  Receipts
//
//  Created by Michael Zornek on 5/15/17.
//  Copyright © 2017 Zorn Labs. All rights reserved.
//
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Private
    
    private func configureInitialViewController() {
        guard let navController = window?.rootViewController as? UINavigationController else {
            assertionFailure("Expect the storyboard to launch with a root navigation controller")
            return
        }
        
        guard let listVC = navController.topViewController as? ReceiptsListViewController else {
            assertionFailure("Expected the navigation controller to launch with a root ReceiptsListViewController instance")
            return
        }
        
        listVC.receiptStore = ReceiptStore(fileURL: DeveloperSettings.receiptStoreFileURL())
    }
    
}
