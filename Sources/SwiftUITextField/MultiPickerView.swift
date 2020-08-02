//
//  MultiPickerView.swift
//  
//
//  Created by Q Trang on 8/2/20.
//

import SwiftUI

public struct MultiPickerView: View {
    typealias Index = Int
    typealias Value = String
    typealias Component = [Value]
    
    let components: [Component]
    @Binding var selection: [Index]
    
    public var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(0..<self.components.count) { column in
                    self.renderComponent(for: column, proxy: proxy)
                }
            }
        }
    }
    
    func renderComponent(for column: Int, proxy: GeometryProxy) -> some View {
        return Picker("", selection: self.$selection[column]) {
            ForEach(0..<self.components[column].count) { row in
                Text(verbatim: self.components[column][row])
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(maxWidth: proxy.frame(in: .global).width/CGFloat(self.components.count))
        .labelsHidden()
        .clipped()
    }
}

