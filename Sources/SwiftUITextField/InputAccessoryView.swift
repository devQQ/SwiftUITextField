//
//  InputAccessoryView.swift
//  
//
//  Created by Q Trang on 8/2/20.
//

import SwiftUI

public struct InputAccessoryView: View {
    public static let DONE = "Done"
    public static let NEXT = "Next"
    public static let PREV = "Previous"
    
    let showNext: Bool
    let nextAction: (() -> Void)?
    let showPrev: Bool
    let prevAction: (() -> Void)?
    let buttonTitle: String
    let buttonAction: (() -> Void)?
    
    public init(showNext: Bool = false, nextAction: (() -> Void)? = nil, showPrev: Bool = false, prevAction: (() -> Void)? = nil, buttonTitle: String = InputAccessoryView.DONE, buttonAction: (() -> Void)? = nil) {
        self.showNext = showNext
        self.nextAction = nextAction
        self.showPrev = showPrev
        self.prevAction = prevAction
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        HStack {
            HStack(spacing: .s24) {
                if showPrev {
                    Button(action: {
                        self.prevAction?()
                    }, label: {
                        Text(InputAccessoryView.PREV)
                            .foregroundColor(Color.systemBlue)
                    })
                }
                
                if showNext {
                    Button(action: {
                        self.nextAction?()
                    }, label: {
                        Text(InputAccessoryView.NEXT)
                            .foregroundColor(Color.systemBlue)
                    })
                }
            }
            
            Spacer()
            Button(action: {
                self.buttonAction?()
            }, label: {
                Text(self.buttonTitle)
            })
                .foregroundColor(Color.systemBlue)
        }
        .frame(maxWidth: .infinity, minHeight: .h44, maxHeight: .h44)
        .pad(edges: .horizontal, spacing: .s16)
        .background(Color.gray100)
        .overlay(Rectangle().stroke(Color.gray300, lineWidth: 1.0))
    }
}

extension InputAccessoryView {
    public static var defaultView: InputAccessoryView {
        InputAccessoryView(buttonAction: {
            UIApplication.shared.hideKeyboard()
        })
    }
}

