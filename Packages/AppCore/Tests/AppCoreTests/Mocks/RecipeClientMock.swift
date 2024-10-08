//
//  File.swift
//  AppCore
//
//  Created by Vitor Ferraz Varela on 06/10/24.
//

import Foundation
import RecipeClient

final class RecipeClientMock: RecipeClientProtocol {
    var expectedDTO: [RecipesDTO]?
    var expectedError: Error?
    
    var fetchRecipesCallCount = 0
    func fetchRecipes() async throws -> [RecipesDTO] {
        fetchRecipesCallCount += 1
        if let expectedError {
            throw expectedError
        }
            
        return expectedDTO!
    }
    
    
}
