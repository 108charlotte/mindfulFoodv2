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
    
    @State private var hasSeenWelcomeScreen: Bool = false
    @State private var hasCompletedTutorial: Bool = false
    
    var body: some View {
        if !hasSeenWelcomeScreen {
            WelcomeScreen(hasSeenWelcomeScreen: $hasSeenWelcomeScreen)
                .onAppear {
                    self.hasSeenWelcomeScreen = UserDefaults.standard.bool(forKey: "hasSeenWelcomeScreen")
                    self.hasCompletedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
                }
        } else if !hasCompletedTutorial {
            TutorialSlideshow(hasCompletedTutorial: $hasCompletedTutorial)
                .onAppear {
                    self.hasSeenWelcomeScreen = UserDefaults.standard.bool(forKey: "hasSeenWelcomeScreen")
                    self.hasCompletedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
                }
        } else {
            
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
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
            print("Successfully deleted")
        }
    }
}

struct TutorialSlideshow: View {
    @Binding var hasCompletedTutorial: Bool
    
    var body: some View {
        ZStack {
            Image("pizza")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.4))

            
            VStack(spacing: 20) {
                Text("Tutorial")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("""
                     Click the plus button on the home screen to add pictures.
                     Once you add a picture and any optional notes, the app will go to your scrapbook page.
                     On this page is a verticle layout depicting all of the images you have uploaded today, and beneath them their description.
                     """)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
                    self.hasCompletedTutorial = true
                }) {
                    Text("To the App!!!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding(.top, 20)
            }.frame(maxWidth: 350)
        }
        .padding()
    }
}

struct WelcomeScreen: View {
    @Binding var hasSeenWelcomeScreen: Bool
    
    var body: some View {
        ZStack {
            Image("spaghetti")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.4))
            
            VStack(spacing: 20) {
                Text("Mindful Food Journal")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("""
                     Thank you for choosing my mindful food journaling app! The goal of this application is to help you be more mindful and in control of your daily intake in a relaxing and healthy way rather than through strict calorie counting.

                     If you have any suggestions on how I can improve, please reach out to me!
                     """)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasSeenWelcomeScreen")
                    self.hasSeenWelcomeScreen = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: 350) // Ensures the text is constrained to a readable width
        }
    }
}

#Preview {
    let dataController = DataController()
    ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
}
