//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Vitor Ferraz Varela on 06/10/24.
//

import SwiftUI
import Presentation
import AppCore

@main
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesList.ContentView(
                dataModel: .init(
                    repository: RepositoryFactory.make()
                )
            )
        }
    }
}
