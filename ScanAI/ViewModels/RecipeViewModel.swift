import Foundation

class RecipeViewModel: ObservableObject {
    private let geminiService: GeminiService
    
    init() {
        self.geminiService = GeminiService(apiKey: "AIzaSyDf26fouXER1VXubgNc9bGaQDD7S-T9C80")
    }
    
    func generateRecipes(from ingredients: [String]) async throws -> Recipe {
        return try await geminiService.generateRecipes(from: ingredients)
    }
} 