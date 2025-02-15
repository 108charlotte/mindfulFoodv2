//
//  AddFoodView.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/15/25.
//
import SwiftUI

struct AddFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var notes = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    @State private var food: Food?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Section(header: Text("Add a Photo")
                            .font(.headline)
                            .padding(.top, 10)) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.bottom, 20)
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.bottom, 20)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Select Image")
                            .fontWeight(.medium)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }.padding(.horizontal)
                }
                
                Section(header: Text("Food Details")) {
                    TextField("Food name", text: $name)
                        .padding(.horizontal)
                    TextField("Description/notes", text: $notes)
                        .padding(.horizontal)
                }
                
                Button("Submit") {
                    if food == nil {
                        food = Food(context: managedObjContext)
                    }
                    if let food = food {
                        food.name = name
                        food.notes = notes
                        
                        if let imageData = selectedImage?.jpegData(compressionQuality: 1.0) {
                            food.image = imageData
                        }
                        
                        DataController().addFood(name: name, notes: notes, image: selectedImage, context: managedObjContext)
                    }
                    
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Add Food")
        }
        .sheet(isPresented: $showImagePicker) {
            let newFood = food ?? Food(context: managedObjContext)
            ImagePicker(selectedImage: $selectedImage, food: newFood)
        }
    }
}
