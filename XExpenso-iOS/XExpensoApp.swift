//
//  XExpenso_iOSApp.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/17/21.
//

import SwiftUI
import CoreData

@main
struct XExpensoApp: App {
    
    init() {
        self.setDefaultPreferences()
    }
    
    private func setDefaultPreferences() {
        let currency = UserDefaults.standard.string(forKey: UD_EXPENSE_CURRENCY)
        if currency == nil {
            UserDefaults.standard.set("$", forKey: UD_EXPENSE_CURRENCY)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ExpenseView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "XExpense")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("未解决的错误 \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
