import Foundation

class SavedRecipesViewModel: ObservableObject {
    @Published private(set) var savedRecipes: [Recipe] = []
    private let savedRecipesKey = "savedRecipes"
    
    init() {
        loadSavedRecipes()
    }
    
    func saveRecipe(_ recipe: Recipe) {
        if !isRecipeSaved(recipe) {
            savedRecipes.append(recipe)
            saveToDisk()
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        savedRecipes.removeAll { $0.id == recipe.id }
        saveToDisk()
    }
    
    func isRecipeSaved(_ recipe: Recipe) -> Bool {
        savedRecipes.contains { $0.id == recipe.id }
    }
    
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(savedRecipes) {
            UserDefaults.standard.set(encoded, forKey: savedRecipesKey)
        }
    }
    
    private func loadSavedRecipes() {
        if let data = UserDefaults.standard.data(forKey: savedRecipesKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            savedRecipes = decoded
        }
    }
} 