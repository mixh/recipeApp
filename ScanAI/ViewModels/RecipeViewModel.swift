import Foundation

class RecipeViewModel: ObservableObject {
    private let geminiService: GeminiService
    
    init() {
        self.geminiService = GeminiService(apiKey: "enter gemini api key here")
    }
    
    func generateRecipes(from ingredients: [String]) async throws -> Recipe {
        return try await geminiService.generateRecipes(from: ingredients)
    }
} 
