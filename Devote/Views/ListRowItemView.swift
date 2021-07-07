//
//  ListRowItemView.swift
//  Devote
//
//  Created by Josh Courtney on 7/1/21.
//

import SwiftUI

struct ListRowItemView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
                .animation(.default)
        } // toggle
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange, perform: { _ in
            if viewContext.hasChanges {
                try? viewContext.save()
            }
        })
    }
}
