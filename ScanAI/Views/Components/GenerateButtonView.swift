import SwiftUI

struct GenerateButtonView: View {
    let isLoading: Bool
    let isEmpty: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: action) {
                HStack(spacing: 15) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.title2)
                    }
                    Text(isLoading ? "Creating Recipe..." : "Create Recipe")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEmpty ? 
                    LinearGradient(colors: [Color(hex: "E0E0E0")], startPoint: .leading, endPoint: .trailing) :
                                        LinearGradient(colors: [Color(hex: "FF5F6D"), Color(hex: "FFC371")], startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(isEmpty ? .gray : .white)
                .cornerRadius(16)
                .shadow(color: isEmpty ? .clear : Color.black.opacity(0.1),
                       radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            .disabled(isEmpty || isLoading)
            .padding(.horizontal)
            
            if isEmpty {
                Text("Add your ingredients to get started")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "555555"))
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
