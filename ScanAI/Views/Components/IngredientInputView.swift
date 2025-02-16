import SwiftUI

struct IngredientInputView: View {
    @Binding var ingredient: String
    let addIngredient: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What ingredients do you have?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            HStack(spacing: 15) {
                TextField("Type an ingredient", text: $ingredient)
                    .font(.title3)
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                
                Button(action: addIngredient) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            ingredient.isEmpty ? 
                            Color(.systemGray3).gradient :
                            Color.blue.gradient
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .disabled(ingredient.isEmpty)
            }
            .padding(.horizontal)
        }
    }
} 