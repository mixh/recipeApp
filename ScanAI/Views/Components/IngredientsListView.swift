import SwiftUI

struct IngredientsListView: View {
    let ingredients: [String]
    let removeIngredient: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Added Ingredients")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                                .font(.body)
                            Spacer()
                            Button(action: { removeIngredient(ingredient) }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 250)
        }
    }
} 