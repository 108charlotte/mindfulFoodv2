//
//  DataController.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/15/25.
//

import Foundation
import CoreData
import PhotosUI


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!!! Yay!")
        } catch {
            print("We could not save the data...:(")
        }
    }
    
    func addFood(name: String, notes: String, image: UIImage?, context: NSManagedObjectContext) -> Food {
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.notes = notes
        
        if let image = image {
            food.image = image.jpegData(compressionQuality: 0.8)
        }
        
        save(context: context)
        
        return food
    }
    
    func editFood(food: Food, name: String, notes: String, image: UIImage?, context: NSManagedObjectContext) {
        food.date = Date()
        food.name = name
        food.notes = notes;
        
        if let image = image {
            food.image = image.jpegData(compressionQuality: 0.8)
        }
        
        save(context: context)
    }
    
}
