//
//  ContentView.swift
//  Devote
//
//  Created by Josh Courtney on 6/21/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task = ""
    @State private var isShowingNewTaskItem = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // HEADER
                    HStack(spacing: 10) {
                        // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(Capsule().stroke(Color.white, lineWidth: 2))
                        
                        // APPEARANCE BUTTON
                        Button(action: {
                            isDarkMode.toggle()
                            play(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        }) {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // NEW TASK BUTTON
                    Button(action: {
                        isShowingNewTaskItem = true
                        play(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    } // button
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0, y: 4)
                    
                    // TASKS
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                            
//                            VStack(alignment: .leading) {
//                                Text(item.task ?? "")
//                                    .font(.headline)
//                                    .fontWeight(.bold)
//
//                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                                    .font(.footnote)
//                                    .foregroundColor(.gray)
//                            } // vstack
                        } // loop
                        .onDelete(perform: deleteItems)
                    } // list
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } // vstack
                .blur(radius: isShowingNewTaskItem ? 0.8 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                
                // NEW TASK ITEM
                if isShowingNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? .black : .gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5
                    )
                        .onTapGesture {
                            withAnimation {
                                isShowingNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $isShowingNewTaskItem)
                }
                
            } // zstack
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
                    .blur(radius: isShowingNewTaskItem ? 0.8 : 0, opaque: false)
            )
            .background(backgroundGradient.ignoresSafeArea(.all))
        } // nav
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
