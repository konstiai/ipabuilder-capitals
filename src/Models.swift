import SwiftUI
import UIKit

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case official = "official"
    case officialAndTerritories = "official_territories"
    case custom = "custom"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .official:
            return "Official Capitals"
        case .officialAndTerritories:
            return "Official + Territories"
        case .custom:
            return "Custom Selection"
        }
    }

    var subtitle: String {
        switch self {
        case .official:
            return "All sovereign countries of the world"
        case .officialAndTerritories:
            return "Includes territories like Guam, American Samoa, Puerto Rico & more"
        case .custom:
            return "Pick and save specific countries & capitals to train only your selection"
        }
    }

    var iconName: String {
        switch self {
        case .official:
            return "globe.europe.africa.fill"
        case .officialAndTerritories:
            return "map.fill"
        case .custom:
            return "checklist"
        }
    }

    var accentColors: [Color] {
        switch self {
        case .official:
            return [Color(red: 0.16, green: 0.48, blue: 0.96), Color(red: 0.08, green: 0.28, blue: 0.78)]
        case .officialAndTerritories:
            return [Color(red: 0.06, green: 0.68, blue: 0.58), Color(red: 0.04, green: 0.45, blue: 0.42)]
        case .custom:
            return [Color(red: 0.58, green: 0.28, blue: 0.92), Color(red: 0.38, green: 0.16, blue: 0.72)]
        }
    }
}

enum InputMode: String, CaseIterable, Identifiable, Codable {
    case strictTyping = "strict"
    case suggestions = "suggestions"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .strictTyping:
            return "Type Yourself"
        case .suggestions:
            return "Suggestions"
        }
    }

    var description: String {
        switch self {
        case .strictTyping:
            return "Write the exact capital yourself. Any spelling mistake counts as wrong."
        case .suggestions:
            return "Matching capitals appear as choices while you type letters."
        }
    }

    var iconName: String {
        switch self {
        case .strictTyping:
            return "keyboard.fill"
        case .suggestions:
            return "sparkle.magnifyingglass"
        }
    }
}

enum AppScreen: Equatable {
    case menu
    case customPicker
    case playing
    case summary
}

struct CountryItem: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let capital: String
    let alternateCapitals: [String]
    let flag: String
    let continent: String
    let isTerritory: Bool

    init(
        id: String,
        name: String,
        capital: String,
        alternateCapitals: [String] = [],
        flag: String,
        continent: String,
        isTerritory: Bool = false
    ) {
        self.id = id
        self.name = name
        self.capital = capital
        self.alternateCapitals = alternateCapitals
        self.flag = flag
        self.continent = continent
        self.isTerritory = isTerritory
    }

    var allAcceptedCapitals: [String] {
        [capital] + alternateCapitals
    }
}

enum SubmissionState: Equatable {
    case none
    case correct(userAnswer: String, matchedCapital: String)
    case incorrect(userAnswer: String, correctCapital: String)

    var isSubmitted: Bool {
        switch self {
        case .none:
            return false
        case .correct, .incorrect:
            return true
        }
    }

    var isCorrect: Bool {
        if case .correct = self { return true }
        return false
    }
}

enum HapticsHelper {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

extension Color {
    static let appCyan = Color(red: 0.20, green: 0.78, blue: 0.96)
    static let appTeal = Color(red: 0.18, green: 0.72, blue: 0.68)
}
