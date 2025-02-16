import SwiftUI

struct SavedRecipesView: View {
    @StateObject private var viewModel = SavedRecipesViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.savedRecipes.isEmpty {
                    emptyStateView
                } else {
                    recipesList
                }
            }
            .navigationTitle("Saved Recipes")
        }
    }
    
    private var recipesList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.savedRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        SavedRecipeCard(recipe: recipe)
                    }
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.circle")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "FFD700"))
            
            Text("No Saved Recipes")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your saved recipes will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.black : Color(hex: "F8F9FA"))
    }
}

struct SavedRecipeCard: View {
    let recipe: Recipe
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack {
                Image(systemName: "basket")
                    .foregroundColor(Color(hex: "FF5F6D"))
                Text("\(recipe.ingredients.count) ingredients")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "list.bullet")
                    .foregroundColor(Color(hex: "FF5F6D"))
                Text("\(recipe.steps.count) steps")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(hex: "1A1A1A") : .white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
} 