//
//  mindfulFoodv2App.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/15/25.
//

import SwiftUI

@main
struct mindfulFoodv2App: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
