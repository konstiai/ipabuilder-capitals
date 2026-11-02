import Foundation
import SwiftUI

final class GameStore: ObservableObject {
    // MARK: - Navigation & Mode State
    @Published var currentScreen: AppScreen = .menu
    @Published var activeMode: GameMode = .official
    @Published var inputMode: InputMode {
        didSet {
            UserDefaults.standard.set(inputMode.rawValue, forKey: Self.inputModeKey)
        }
    }

    // MARK: - Persistent Custom Selection
    @Published var customSelectedIds: Set<String> {
        didSet {
            saveCustomSelection()
        }
    }

    // MARK: - Persistent Last Accuracy Per Mode
    @Published var lastAccuracyByMode: [String: Int] = [:]

    // MARK: - Active Round State
    @Published var remainingQueue: [CountryItem] = []
    @Published var totalCardsInRound: Int = 0
    @Published var completedCount: Int = 0
    @Published var repeatLaterIds: Set<String> = []

    @Published var typedText: String = ""
    @Published var submissionState: SubmissionState = .none

    // Round Scoring
    @Published var totalAttempts: Int = 0
    @Published var correctAttempts: Int = 0
    @Published var wrongAttempts: Int = 0
    @Published var repeatQueuedCountTotal: Int = 0
    private var answeredCountryIds: Set<String> = []
    @Published var firstTryCorrectCount: Int = 0

    // Storage Keys
    private static let customSelectionKey = "geogame_custom_selected_country_ids_v1"
    private static let inputModeKey = "geogame_input_mode_v1"
    private static let lastAccuracyKey = "geogame_last_accuracy_by_mode_v1"

    init() {
        if let savedModeRaw = UserDefaults.standard.string(forKey: Self.inputModeKey),
           let savedMode = InputMode(rawValue: savedModeRaw) {
            self.inputMode = savedMode
        } else {
            self.inputMode = .strictTyping
        }

        if let savedIds = UserDefaults.standard.stringArray(forKey: Self.customSelectionKey) {
            self.customSelectedIds = Set(savedIds)
        } else {
            self.customSelectedIds = []
        }

        if let savedScores = UserDefaults.standard.dictionary(forKey: Self.lastAccuracyKey) as? [String: Int] {
            self.lastAccuracyByMode = savedScores
        } else {
            self.lastAccuracyByMode = [:]
        }
    }

    // MARK: - Computed Properties
    var currentCountry: CountryItem? {
        remainingQueue.first
    }

    var currentSuggestions: [String] {
        guard inputMode == .suggestions,
              !submissionState.isSubmitted,
              !typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        return CountryDatabase.capitalSuggestions(for: typedText, in: activeMode)
    }

    var accuracyPercentage: Int {
        guard totalAttempts > 0 else { return 0 }
        let ratio = (Double(correctAttempts) / Double(totalAttempts)) * 100.0
        return min(100, max(0, Int(ratio.rounded())))
    }

    var firstTryAccuracyPercentage: Int {
        guard totalCardsInRound > 0 else { return 0 }
        let ratio = (Double(firstTryCorrectCount) / Double(totalCardsInRound)) * 100.0
        return min(100, max(0, Int(ratio.rounded())))
    }

    var roundProgressFraction: Double {
        guard totalCardsInRound > 0 else { return 0 }
        return Double(completedCount) / Double(totalCardsInRound)
    }

    var customSelectedCountries: [CountryItem] {
        CountryDatabase.allItems.filter { customSelectedIds.contains($0.id) }
    }

    // MARK: - Custom Selection Management
    func saveCustomSelection() {
        let array = Array(customSelectedIds).sorted()
        UserDefaults.standard.set(array, forKey: Self.customSelectionKey)
    }

    func toggleCustomCountry(_ id: String) {
        HapticsHelper.impact(.light)
        if customSelectedIds.contains(id) {
            customSelectedIds.remove(id)
        } else {
            customSelectedIds.insert(id)
        }
    }

    func resetCustomSelection() {
        HapticsHelper.notification(.warning)
        customSelectedIds.removeAll()
        saveCustomSelection()
    }

    func selectAll(from items: [CountryItem]) {
        HapticsHelper.impact(.medium)
        for item in items {
            customSelectedIds.insert(item.id)
        }
        saveCustomSelection()
    }

    func deselectAll(from items: [CountryItem]) {
        HapticsHelper.impact(.light)
        for item in items {
            customSelectedIds.remove(item.id)
        }
        saveCustomSelection()
    }

    // MARK: - Starting & Managing Rounds
    func selectModeFromMenu(_ mode: GameMode) {
        HapticsHelper.impact(.medium)
        activeMode = mode

        switch mode {
        case .official, .officialAndTerritories:
            startRound(for: mode)
        case .custom:
            if customSelectedIds.isEmpty {
                currentScreen = .customPicker
            } else {
                startRound(for: .custom)
            }
        }
    }

    func openCustomPicker() {
        HapticsHelper.impact(.light)
        activeMode = .custom
        currentScreen = .customPicker
    }

    func startRound(for mode: GameMode) {
        activeMode = mode
        let pool: [CountryItem]
        switch mode {
        case .official:
            pool = CountryDatabase.officialCountries
        case .officialAndTerritories:
            pool = CountryDatabase.allItems
        case .custom:
            pool = customSelectedCountries
        }

        guard !pool.isEmpty else {
            currentScreen = .customPicker
            return
        }

        remainingQueue = pool.shuffled()
        totalCardsInRound = pool.count
        completedCount = 0
        repeatLaterIds.removeAll()
        typedText = ""
        submissionState = .none

        totalAttempts = 0
        correctAttempts = 0
        wrongAttempts = 0
        repeatQueuedCountTotal = 0
        answeredCountryIds.removeAll()
        firstTryCorrectCount = 0

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .playing
        }
    }

    func restartCurrentMode() {
        HapticsHelper.impact(.medium)
        startRound(for: activeMode)
    }

    func returnToMenu() {
        HapticsHelper.impact(.light)
        typedText = ""
        submissionState = .none
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .menu
        }
    }

    // MARK: - Answer Submission & Progression
    func submitAnswer(overrideText: String? = nil) {
        guard let country = currentCountry else { return }
        let rawInput = (overrideText ?? typedText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawInput.isEmpty else { return }

        if let overrideText = overrideText {
            typedText = overrideText
        }

        let check = CountryDatabase.isAnswerCorrect(rawInput, for: country)
        totalAttempts += 1

        let isFirstAttemptForCountry = !answeredCountryIds.contains(country.id)
        answeredCountryIds.insert(country.id)

        if check.isCorrect {
            correctAttempts += 1
            if isFirstAttemptForCountry {
                firstTryCorrectCount += 1
            }
            HapticsHelper.notification(.success)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                submissionState = .correct(userAnswer: rawInput, matchedCapital: country.capital)
            }
        } else {
            wrongAttempts += 1
            HapticsHelper.notification(.error)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                submissionState = .incorrect(userAnswer: rawInput, correctCapital: country.capital)
            }
        }
    }

    /// Re-type immediately on the current card (useful in Strict Mode when you make a typo and want to type it again right now)
    func retryTypingCurrentCard() {
        HapticsHelper.impact(.light)
        withAnimation(.easeInOut(duration: 0.2)) {
            typedText = ""
            submissionState = .none
        }
    }

    /// Put the current country back into the queue to be asked again later in this round ("Nochmal abfragen")
    func repeatLater() {
        guard !remainingQueue.isEmpty else { return }
        HapticsHelper.impact(.medium)

        let current = remainingQueue.removeFirst()
        repeatLaterIds.insert(current.id)
        repeatQueuedCountTotal += 1

        if remainingQueue.isEmpty {
            // Only 1 card left in the entire round, so it stays as the current card to be asked again immediately
            remainingQueue.append(current)
        } else if remainingQueue.count <= 3 {
            remainingQueue.append(current)
        } else {
            // Insert somewhere in the second half of the remaining queue so it comes back later
            let minIndex = max(1, remainingQueue.count / 2)
            let insertIndex = Int.random(in: minIndex...remainingQueue.count)
            remainingQueue.insert(current, at: insertIndex)
        }

        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            typedText = ""
            submissionState = .none
        }
    }

    /// Mark the current country as completed for this round so it won't be asked again ("Weiter")
    func nextCountry() {
        guard !remainingQueue.isEmpty else { return }
        HapticsHelper.impact(.light)

        let finished = remainingQueue.removeFirst()
        repeatLaterIds.remove(finished.id)
        completedCount += 1

        typedText = ""
        submissionState = .none

        if remainingQueue.isEmpty {
            // Round finished! Save accuracy and transition to Summary screen
            lastAccuracyByMode[activeMode.rawValue] = accuracyPercentage
            UserDefaults.standard.set(lastAccuracyByMode, forKey: Self.lastAccuracyKey)
            HapticsHelper.notification(.success)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                currentScreen = .summary
            }
        }
    }
}
