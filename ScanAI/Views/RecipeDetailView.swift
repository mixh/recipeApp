import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var savedRecipesVM = SavedRecipesViewModel()
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                // Title Section with Save Button
                HStack(alignment: .top) {
                    Text(recipe.title)
                        .font(.system(.title, design: .default))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: toggleSave) {
                        Image(systemName: savedRecipesVM.isRecipeSaved(recipe) ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundStyle(
                                savedRecipesVM.isRecipeSaved(recipe) ? 
                                Color(hex: "FFD700") : Color(hex: "555555")
                            )
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                // Ingredients Section
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "basket.fill")
                            .foregroundStyle(Color(hex: "00C6FB"))
                        Text("Ingredients")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color(hex: "00C6FB"))
                                    .font(.system(size: 20))
                                Text(ingredient)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? Color(hex: "1A1A1A") : .white)
                        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                // Steps Section
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "list.bullet.circle.fill")
                            .foregroundStyle(Color(hex: "00C6FB"))
                        Text("Instructions")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(recipe.steps.enumerated()), id: \.element) { index, step in
                            HStack(alignment: .top, spacing: 15) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(
                                        LinearGradient(colors: [Color(hex: "00C6FB"), Color(hex: "005BEA")],
                                                      startPoint: .topLeading,
                                                      endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(15)
                                
                                Text(step)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? Color(hex: "1A1A1A") : .white)
                        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
                )
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .background(colorScheme == .dark ? Color.black : Color(hex: "F8F9FA"))
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            saveConfirmationToast
                .opacity(showingSaveConfirmation ? 1 : 0)
        )
    }
    
    private func toggleSave() {
        if savedRecipesVM.isRecipeSaved(recipe) {
            savedRecipesVM.removeRecipe(recipe)
        } else {
            savedRecipesVM.saveRecipe(recipe)
        }
        
        withAnimation {
            showingSaveConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingSaveConfirmation = false
            }
        }
    }
    
    private var saveConfirmationToast: some View {
        Text(savedRecipesVM.isRecipeSaved(recipe) ? "Recipe Saved!" : "Recipe Removed")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.8))
            )
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
} 