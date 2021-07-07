//
//  CheckboxStyle.swift
//  Devote
//
//  Created by Josh Courtney on 7/1/21.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    feedback.notificationOccurred(.success)
                    
                    if configuration.isOn {
                        play(sound: "sound-rise", type: "mp3")
                    } else {
                        play(sound: "sound-tap", type: "mp3")
                    }
                }
            
            configuration.label
        } // hstack
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Label", isOn: .constant(false))
            .toggleStyle(CheckboxStyle())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
