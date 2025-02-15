//
//  ContentView.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/15/25.
//


import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(
        entity: Food.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.date, ascending: false)]
    ) var food: FetchedResults<Food>
    
    @State private var showingAddView = false
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if food.isEmpty {
                    Text("No entries yet!")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                List {
                    ForEach(food) { foodItem in
                        if let name = foodItem.name, let notes = foodItem.notes, let date = foodItem.date {
                            if Calendar.current.isDateInToday(date) {
                                NavigationLink(destination: EditFoodView(food: foodItem)) {
                                    VStack {
                                        if let imageData = foodItem.image, let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                                .cornerRadius(12)
                                                .padding(.bottom, 20)
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 6) {
                                                
                                                Text(name)
                                                    .bold()
                                                
                                                Text(notes)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Text(calcTimeSince(date: date))
                                                .foregroundColor(.gray)
                                                .italic()
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("Incomplete Entry")
                                .foregroundColor(.red)
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
                
            }
            .padding()
            .navigationTitle("Mindful Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
            .navigationViewStyle(.stack) // Make sure it's applied after all toolbar and content code
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
            print("Successfully deleted")
        }
    }
}

#Preview {
    let dataController = DataController()
    ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
}
