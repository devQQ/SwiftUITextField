//
//  SwiftUITextField.swift
//
//
//  Created by Q Trang on 8/1/20.
//

import SwiftUI
import SwiftUIStyleKit

public struct SwiftUITextField<U: View, V: View>: UIViewRepresentable {
    public class Coordinator: NSObject, UITextFieldDelegate {
        private let parent: SwiftUITextField
        private let onEditingChanged: (Bool) -> Void
        private let onCommit: (String) -> Void
        private let isInputViewActive: Bool
        
        @Binding var isFirstResponder: Bool
        
        let formatText: ((String) -> String)?
        let returnKeyAction: (() -> Void)?
        let shouldChangeCharacters: ((_ currentText: String?, _ replacementString: String) -> Bool)?
        
        public init(_ parent: SwiftUITextField,
                    onEditingChanged: @escaping (Bool) -> Void = { _ in },
                    onCommit: @escaping (String) -> Void = {_ in },
                    isInputViewActive: Bool,
                    isFirstResponder: Binding<Bool>,
                    formatText: ((String) -> String)? = nil,
                    returnKeyAction:  (() -> Void)? = nil,
                    shouldChangeCharacters: ((_ currentText: String?, _ replacementString: String) -> Bool)? = nil) {
            self.parent = parent
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
            self.isInputViewActive = isInputViewActive
            self._isFirstResponder = isFirstResponder
            self.formatText = formatText
            self.returnKeyAction = returnKeyAction
            self.shouldChangeCharacters = shouldChangeCharacters
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder = true
            self.onEditingChanged(true)
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            //check if input is active and prevent changes in text
            guard !isInputViewActive else {
                return false
            }
            
            //Check for return key
            guard string != "\n" else {
                self.returnKeyAction?()
                return false
            }
            
            guard shouldChangeCharacters?(textField.text, string) ?? true else {
                return false
            }
            
            if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
                guard newText.count <= parent.characterLimit || formatText != nil else {
                    return false
                }
                
                if let formatText = formatText {
                    let formattedText = formatText(newText)
                    
                    guard formattedText.count <= parent.characterLimit else {
                        return false
                    }
                    
                    self.parent.text = formattedText
                } else {
                    self.parent.text = newText
                }
                
                return true
            } else {
                return false
            }
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            self.isFirstResponder = false
            self.onEditingChanged(false)
            
            guard reason == .committed else {
                return
            }
            
            self.onCommit(textField.text ?? "")
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.onEditingChanged(false)
        }
    }
    
    public let placeholder: String
    @Binding public var text: String
    @Binding public var textColor: UIColor
    public let characterLimit: Int
    public let onEditingChanged: (Bool) -> Void
    public let onCommit: () -> Void
    public let inputView: U?
    public let inputAccessoryView: V?
    public let keyboardType: UIKeyboardType
    public let returnKeyType: UIReturnKeyType
    public let autocapitalizationType: UITextAutocapitalizationType
    public let autoCorrectionType: UITextAutocorrectionType
    public let isSecureTextEntry: Bool

    @Binding public var isFirstResponder: Bool
    @Binding public var shouldBecomeFirstResponder: Bool
    @Binding public var shouldResignFirstResponder: Bool
    
    let formatText: ((String) -> String)?
    let returnKeyAction: (() -> Void)?
    let shouldChangeCharacter: ((_ currentText: String?, _ replacementString: String) -> Bool)?
    
    public init(_ placeholder: String,
                text: Binding<String>,
                textColor: Binding<UIColor>,
                characterLimit: Int,
                onEditingChanged: @escaping (Bool) -> Void = { _ in },
                onCommit: @escaping () -> Void = {},
                inputView: ( () -> U)? = nil,
                inputAccessoryView: ( () -> V)? = nil,
                keyboardType: UIKeyboardType = .default,
                returnKeyType: UIReturnKeyType = .default,
                autocapitalizationType: UITextAutocapitalizationType = .words,
                autoCorrectionType: UITextAutocorrectionType = .default,
                isSecureTextEntry: Bool = false,
                isFirstResponder: Binding<Bool>,
                shouldBecomeFirstResponder: Binding<Bool>,
                shouldResignFirstResponder: Binding<Bool>,
                formatText: ((String) -> String)? = nil,
                returnKeyAction: (() -> Void)? = nil,
                shouldChangeCharacter: ((_ currentText: String?, _ replacementString: String) -> Bool)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self._textColor = textColor
        self.characterLimit = characterLimit
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.inputView = inputView?()
        self.inputAccessoryView = inputAccessoryView?()
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.autocapitalizationType = autocapitalizationType
        self.autoCorrectionType = autoCorrectionType
        self.isSecureTextEntry = isSecureTextEntry
        self._isFirstResponder = isFirstResponder
        self._shouldBecomeFirstResponder = shouldBecomeFirstResponder
        self._shouldResignFirstResponder = shouldResignFirstResponder
        self.formatText = formatText
        self.returnKeyAction = returnKeyAction
        self.shouldChangeCharacter = shouldChangeCharacter
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.textColor = textColor
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autoCorrectionType
        textField.delegate = context.coordinator

        if let inputView = inputView {
            let view = createUIView(for: inputView, height: 256)
            textField.inputView = view
            //hide editing cursor
            textField.tintColor = .clear
        }
        
        if let accessoryInputView = inputAccessoryView {
            let view = createUIView(for: accessoryInputView, height: 44)
            textField.inputAccessoryView = view
        }
        
        return textField
    }
    
    private func createUIView<Content: View>(for content: Content, height: CGFloat) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        let view = hostingController.view!
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
        return view
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.textColor = textColor
        uiView.text = text
        
        if shouldBecomeFirstResponder && !isFirstResponder {
            uiView.becomeFirstResponder()
            self.shouldBecomeFirstResponder = false
        } else if shouldResignFirstResponder && isFirstResponder {
            uiView.resignFirstResponder()
            shouldResignFirstResponder = false
        }
    }
    
    public func becomeFirstResponder() {
        shouldBecomeFirstResponder = true
    }
    
    public func resignFirstResponder() {
        shouldResignFirstResponder = true
    }
    
    func onCommit(_ text: String) {
        self.text = text
        self.onCommit()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, onEditingChanged: onEditingChanged, onCommit: onCommit, isInputViewActive: self.inputView != nil, isFirstResponder: self.$isFirstResponder, formatText: formatText, returnKeyAction: returnKeyAction, shouldChangeCharacters: shouldChangeCharacter)
    }
}

