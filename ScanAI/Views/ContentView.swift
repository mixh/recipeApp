import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var ingredient = ""
    @State private var ingredients: [String] = []
    @State private var recipe: Recipe?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showingRecipe = false
    
    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        IngredientInputView(
                            ingredient: $ingredient,
                            addIngredient: addIngredient
                        )
                        
                        if !ingredients.isEmpty {
                            IngredientsListView(
                                ingredients: ingredients,
                                removeIngredient: removeIngredient
                            )
                        }
                        
                        Spacer()
                        
                        GenerateButtonView(
                            isLoading: isLoading,
                            isEmpty: ingredients.isEmpty,
                            action: generateRecipes
                        )
                        .padding(.bottom, 30)
                    }
                }
                .navigationTitle("Recipe Creator")
                .navigationDestination(isPresented: $showingRecipe) {
                    if let recipe = recipe {
                        RecipeDetailView(recipe: recipe)
                    }
                }
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Create")
            }
            
            SavedRecipesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Saved")
                }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
    }
    
    // Add ingredient function
    private func addIngredient() {
        let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty && !ingredients.contains(trimmedIngredient) {
            ingredients.append(trimmedIngredient)
            ingredient = ""
        }
    }
    
    // Remove ingredient function
    private func removeIngredient(_ ingredient: String) {
        ingredients.removeAll { $0 == ingredient }
    }
    
    // Generate recipes function
    private func generateRecipes() {
        guard !ingredients.isEmpty else {
            errorMessage = "Please add some ingredients first"
            showError = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let generatedRecipe = try await viewModel.generateRecipes(from: ingredients)
                DispatchQueue.main.async {
                    recipe = generatedRecipe
                    isLoading = false
                    showingRecipe = true
                }
            } catch {
                DispatchQueue.main.async {
                    if let geminiError = error as? GeminiService.GeminiError {
                        errorMessage = geminiError.errorDescription
                    } else {
                        errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    }
                    showError = true
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 