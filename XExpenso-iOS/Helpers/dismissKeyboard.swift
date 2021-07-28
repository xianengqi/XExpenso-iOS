//
//  dismissKeyBoardOnTap.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/28/21.
//

import SwiftUI

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {
    
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(tapGesture)
        #endif
    }
    
    public var tapGesture: some Gesture {
        TapGesture().onEnded(endEditing)
    }
    
    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap({ $0 })
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.endEditing(true)
    }
}
