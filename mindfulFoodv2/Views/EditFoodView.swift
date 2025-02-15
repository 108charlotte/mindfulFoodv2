//
//  EditFoodView.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/15/25.
//

import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var notes = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Section(header: Text("Edit Photo")
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
                                }
                            }.padding(.horizontal)

                }.padding(.vertical)
                
                    
                    Section(header: Text("Edit Food")) {
                        TextField("\(name)", text: $name)
                            .onAppear {
                                name = food.name!
                                notes = food.notes!
                                
                                if let imageData = food.image,
                                    let image = UIImage(data: imageData) {
                                    selectedImage = image
                                }

                            }
                            .padding(.horizontal)
                        TextField("\(notes)", text: $notes)
                            .onAppear {
                                name = food.name!
                                notes = food.notes!
                            }
                            .padding(.horizontal)
                    }
                    Button("Submit") {
                        DataController().editFood(food: food, name: name, notes: notes, image: selectedImage, context: managedObjContext)
                        dismiss()
                    }
                }.navigationTitle("Edit Food")
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage, food: food)
                    }.onAppear {
                        name = food.name ?? ""
                        notes = food.notes ?? ""
                    }
            }
    }
