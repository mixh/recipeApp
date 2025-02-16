import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    let title: String
    let ingredients: [String]
    let steps: [String]
    
    init(id: UUID = UUID(), title: String, ingredients: [String], steps: [String]) {
        self.id = id
        self.title = title
        self.ingredients = ingredients
        self.steps = steps
    }
} 