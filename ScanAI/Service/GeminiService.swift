import Foundation

class GeminiService {
    private let apiKey: String
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateRecipes(from ingredients: [String]) async throws -> Recipe {
        guard !ingredients.isEmpty else {
            throw GeminiError.noIngredients
        }
        
        let prompt = """
        Create a recipe using these ingredients: \(ingredients.joined(separator: ", ")).
        Format your response exactly like this:
        Title: [Recipe Name]
        Ingredients:
        - [ingredient 1]
        - [ingredient 2]
        Steps:
        1. [step 1]
        2. [step 2]
        """
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "topK": 40,
                "topP": 0.95,
                "maxOutputTokens": 1000
            ]
        ]
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            print("API Error Response: \(String(data: data, encoding: .utf8) ?? "No error message")")
            throw GeminiError.apiError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
            return try parseRecipeFromResponse(response)
        } catch {
            print("Parsing Error: \(error)")
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw GeminiError.parsingError
        }
    }
    
    private func parseRecipeFromResponse(_ response: GeminiResponse) throws -> Recipe {
        guard let text = response.candidates.first?.content.parts.first?.text else {
            throw GeminiError.invalidResponse
        }
        
        let lines = text.components(separatedBy: .newlines)
        var title = ""
        var ingredients: [String] = []
        var steps: [String] = []
        var currentSection = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty { continue }
            
            if trimmedLine.lowercased().starts(with: "title:") {
                title = trimmedLine.replacingOccurrences(of: "Title:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmedLine.lowercased().starts(with: "ingredients:") {
                currentSection = "ingredients"
            } else if trimmedLine.lowercased().starts(with: "steps:") {
                currentSection = "steps"
            } else if trimmedLine.starts(with: "-") || trimmedLine.starts(with: "•") {
                let ingredient = trimmedLine.trimmingCharacters(in: CharacterSet(charactersIn: "-• "))
                if currentSection == "ingredients" {
                    ingredients.append(ingredient)
                }
            } else if let stepNumber = trimmedLine.first, stepNumber.isNumber {
                let step = trimmedLine.dropFirst(2).trimmingCharacters(in: .whitespaces)
                if currentSection == "steps" {
                    steps.append(step)
                }
            }
        }
        
        guard !title.isEmpty, !ingredients.isEmpty, !steps.isEmpty else {
            throw GeminiError.parsingError
        }
        
        return Recipe(title: title, ingredients: ingredients, steps: steps)
    }
}

// Response models
struct GeminiResponse: Codable {
    let candidates: [Candidate]
}

struct Candidate: Codable {
    let content: Content
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String
}

// Error handling
extension GeminiService {
    enum GeminiError: LocalizedError {
        case invalidURL
        case invalidResponse
        case parsingError
        case apiError(statusCode: Int)
        case noIngredients
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid API URL"
            case .invalidResponse:
                return "Invalid response from server"
            case .parsingError:
                return "Failed to parse recipe data"
            case .apiError(let statusCode):
                return "API error with status code: \(statusCode)"
            case .noIngredients:
                return "No ingredients provided"
            }
        }
    }
} 