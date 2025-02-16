# Recipe Generator iOS App

A SwiftUI-based iOS application that helps users generate recipes based on available ingredients using Google's Gemini AI API.

## Features

- 🧂 Add and remove ingredients from your inventory
- 🤖 AI-powered recipe generation using Google Gemini
- ⭐️ Save favorite recipes for later reference
- 🌓 Supports both light and dark mode
- 📱 Modern iOS design with smooth animations
- 💾 Persistent storage of saved recipes

## Screenshots



## Technologies Used

- SwiftUI
- Google Gemini AI API
- UserDefaults for persistence
- Async/Await for API calls
- MVVM Architecture

## Installation
1. Clone the repository
2. Open the project in Xcode
3. Add your Google Gemini API key in `RecipeViewModel.swift`
4. Build and run the project

## Usage

1. Launch the app
2. Add ingredients you have available
3. Click "Create Recipe" to generate a recipe
4. Save interesting recipes by clicking the star button
5. Access saved recipes in the "Saved" tab

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:
- **Models**: Data structures like Recipe
- **Views**: SwiftUI views for UI
- **ViewModels**: Business logic and data management

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
- Google Gemini AI for recipe generation
