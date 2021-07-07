//
//  Constants.swift
//  Devote
//
//  Created by Josh Courtney on 6/21/21.
//

import SwiftUI

// FORMATTER
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// UI
var backgroundGradient: LinearGradient {
    LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

// UX
let feedback = UINotificationFeedbackGenerator()
