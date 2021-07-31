//
//  ExpenseDetailViewModel.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/31/21.
//

import UIKit
import CoreData

class ExpenseDetailViewModel: ObservableObject {
    
    @Published var expenseObj: XExpenseCD
    
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false
    
    init(expenseObj: XExpenseCD) {
        self.expenseObj = expenseObj
    }
    
    func deleteNote(managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save(); closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }
   
    func shareNote() {
        let shareStr = """
        名称: \(expenseObj.title ?? "")
        金额: \(UserDefaults.standard.string(forKey: UD_EXPENSE_CURRENCY) ?? "")\(expenseObj.amount)
        收|支类型: \(expenseObj.type == TRANS_TYPE_INCOME ? "收入": "支出")
        类别: \(getTransTagTitle(transTag: expenseObj.tag ?? ""))
        创建时间: \(getDateFormatter(date: expenseObj.occuredOn, format: "EEEE, dd MMM hh:mm a"))
        笔记: \(expenseObj.note ?? "")
     
        \(SHARED_FROM_XEXPENSO)
     """
        let av = UIActivityViewController(activityItems: [shareStr], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}
