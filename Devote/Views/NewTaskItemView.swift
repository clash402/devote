//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Josh Courtney on 6/21/21.
//

import SwiftUI

struct NewTaskItemView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool { task.isEmpty }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                
                Button(action: {
                    addItem()
                    play(sound: "sound-ding", type: "mp3")
                    feedback.notificationOccurred(.success)
                }) {
                    Spacer()
                    
                    Text("Save".uppercased())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Spacer()
                } // button
                .disabled(isButtonDisabled)
                .onTapGesture {
                    if isButtonDisabled {
                        play(sound: "sound-tap", type: "mp3")
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)
            } // vstack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        } // vstack
        .padding()
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .previewDevice("iPhone 11")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
