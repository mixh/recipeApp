import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recipe.title)
                .font(.title2)
                .bold()
            
            Text("Ingredients:")
                .font(.headline)
            ForEach(recipe.ingredients, id: \.self) { ingredient in
                Text("• \(ingredient)")
            }
            
            Text("Steps:")
                .font(.headline)
                .padding(.top, 5)
            ForEach(Array(recipe.steps.enumerated()), id: \.element) { index, step in
                Text("\(index + 1). \(step)")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 