//
//  AddExpenseViewModel.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/23/21.
//
import UIKit
import CoreData

class AddExpenseViewModel: ObservableObject {
    var expenseObj: XExpenseCD?
    
    @Published var title = ""
    @Published var amount = ""
    @Published var occuredOn = Date()
    @Published var note = ""
    @Published var typeTitle = "收入"
    @Published var tagTitle = getTransTagTitle(transTag: TRANS_TAG_TRANSPORT)
    @Published var showTypeDrop = false
    @Published var showTagDrop = false
    
    @Published var selectedType = TRANS_TYPE_INCOME
    @Published var selectedTag = TRANS_TAG_TRANSPORT
    
    @Published var imageUpdated = false // When transaction edit, check if attachment is updated?
    @Published var imageAttached: UIImage? = nil
    
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false
    
    init(expenseObj: XExpenseCD? = nil) {
        
        self.expenseObj  = expenseObj
        self.title = expenseObj?.title ?? ""
        if let expenseObj = expenseObj {
            self.amount = String(expenseObj.amount)
            self.typeTitle = expenseObj.type == TRANS_TYPE_INCOME ? "收入" : "花费"
        } else {
            self.amount = ""
            self.typeTitle = "收入"
        }
        self.occuredOn = expenseObj?.occuredOn ?? Date()
        self.note = expenseObj?.note ?? ""
        self.tagTitle = getTransTagTitle(transTag: expenseObj?.tag ?? TRANS_TAG_TRANSPORT)
        self.selectedType = expenseObj?.type ?? TRANS_TYPE_INCOME
        self.selectedTag = expenseObj?.tag ?? TRANS_TAG_TRANSPORT
        if let data = expenseObj?.imageAttached {
            self.imageAttached = UIImage(data: data)
        }
        
       // AttachmentHandler
    }
}
