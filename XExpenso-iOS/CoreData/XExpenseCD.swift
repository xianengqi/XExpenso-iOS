//
//  ExpenseCD.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/22/21.
//

import Foundation
import CoreData

enum ExpenseCDSort: String {
    case createdAt
    case updatedAt
    case occuredOn
}

enum ExpenseCDFilterTime: String {
    case all
    case week
    case month
}

public class XExpenseCD: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var updateAt: Date?
    @NSManaged public var amount: Double
    @NSManaged public var imageAttached: Data?
    @NSManaged public var note: String?
    @NSManaged public var occuredOn: Date?
    @NSManaged public var tag: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
}


extension XExpenseCD {
    static func getAllExpenseData(sortBy: ExpenseCDSort = .occuredOn, ascending: Bool = true, filterTime: ExpenseCDFilterTime = .all) -> NSFetchRequest<XExpenseCD> {
        let request: NSFetchRequest<XExpenseCD> = XExpenseCD.fetchRequest() as! NSFetchRequest<XExpenseCD>
        let sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
//        if filterTime == .week {
//            let startDate: NSDate = Date().get
//        }
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
