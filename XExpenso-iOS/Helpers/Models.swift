//
//  Models.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/20/21.
//
import UIKit
import SwiftUI

// Lazy Navigation to load (constructor) after clicked on Button
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) { self.build = build }
    var body: Content { build() }
}

struct ToolbarModelView: View {
    
}

