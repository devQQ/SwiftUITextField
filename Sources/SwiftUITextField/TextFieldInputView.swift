//
//  TextFieldInputView.swift
//  
//
//  Created by Q Trang on 8/2/20.
//

import SwiftUI

public struct TextFieldInputView<Content: View>: View {
    let showInputAccessory: Bool
    let showNext: Bool
    let nextAction: (() -> Void)?
    let showPrev: Bool
    let prevAction: (() -> Void)?
    let buttonTitle: String
    let buttonAction: (() -> Void)?
    
    let content: Content
    
    public init(showInputAccessory: Bool = false, showNext: Bool = false, nextAction: (() -> Void)? = nil, showPrev: Bool = false, prevAction: (() -> Void)? = nil, buttonTitle: String = InputAccessoryView.DONE, buttonAction: (() -> Void)? = nil, @ViewBuilder _ content: @escaping () -> Content) {
        self.showInputAccessory = showInputAccessory
        self.showNext = showNext
        self.nextAction = nextAction
        self.showPrev = showPrev
        self.prevAction = prevAction
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if showInputAccessory {
                InputAccessoryView(showNext: showNext, nextAction: nextAction, showPrev: showPrev, prevAction: prevAction, buttonTitle: buttonTitle, buttonAction: buttonAction)
            }
            
            content
        }
        .edgesIgnoringSafeArea(.bottom)
        .eraseToAnyView()
    }
}

