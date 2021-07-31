//
//  Configs.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/18/21.
//

import Foundation

// App Globals
let APP_NAME = "XExpenso"
let APP_LINK = "https://github.com/xianengqi/XExpenso-iOS"
let SHARED_FROM_XEXPENSO = """
    Shared from \(APP_NAME) APP: \(APP_LINK)
"""

// IMAGE_ICON NAMES
let IMAGE_DELETE_ICON = "delete_icon"
let IMAGE_SHARE_ICON = "share_icon"
let IMAGE_FILTER_ICON = "filter_icon"
let IMAGE_OPTION_ICON = "settings_icon"

// User Defaults
let UD_USE_BIOMETRICE = "useBiometric"
let UD_EXPENSE_CURRENCY = "expenseCurrency"

let CURRENCY_LIST = ["₹", "$", "€", "¥", "£", "¢", "₭"]

// Transaction types
let TRANS_TYPE_INCOME = "income"
let TRANS_TYPE_EXPENSE = "expense"

// Transaction tags
let TRANS_TAG_TRANSPORT = "运输"
let TRANS_TAG_FOOD = "食物"
let TRANS_TAG_HOUSING = "房子"
let TRANS_TAG_INSURANCE = "保险"
let TRANS_TAG_MEDICAL = "医疗"
let TRANS_TAG_SAVINGS = "储蓄"
let TRANS_TAG_PERSONAL = "个人"
let TRANS_TAG_ENTERTAINMENT = "娱乐"
let TRANS_TAG_OTHERS = "其他"
let TRANS_TAG_UTILITIES = "公共"

func getTransTagIcon(transTag: String) -> String {
    switch transTag {
        case TRANS_TAG_TRANSPORT: return "trans_type_transport"
        case TRANS_TAG_FOOD: return "trans_type_food"
        case TRANS_TAG_HOUSING: return "trans_type_housing"
        case TRANS_TAG_INSURANCE: return "trans_type_insurance"
        case TRANS_TAG_MEDICAL: return "trans_type_medical"
        case TRANS_TAG_SAVINGS: return "trans_type_savings"
        case TRANS_TAG_PERSONAL: return "trans_type_personal"
        case TRANS_TAG_ENTERTAINMENT: return "trans_type_entertainment"
        case TRANS_TAG_OTHERS: return "trans_type_others"
        case TRANS_TAG_UTILITIES: return "trans_type_utilities"
        default: return "trans_type_others"
    }
}

func getTransTagTitle(transTag: String) -> String {
    switch transTag {
        case TRANS_TAG_TRANSPORT: return "类别"
        case TRANS_TAG_FOOD: return "食物"
        case TRANS_TAG_HOUSING: return "住房"
        case TRANS_TAG_INSURANCE: return "保险"
        case TRANS_TAG_MEDICAL: return "医疗"
        case TRANS_TAG_SAVINGS: return "储蓄"
        case TRANS_TAG_PERSONAL: return "个人"
        case TRANS_TAG_ENTERTAINMENT: return "娱乐"
        case TRANS_TAG_OTHERS: return "其它"
        case TRANS_TAG_UTILITIES: return "水电"
        default: return "Unknown"
    }
}

func getDateFormatter(date: Date?, format: String = "yyyy-MM-dd") -> String {
    guard let date = date else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
