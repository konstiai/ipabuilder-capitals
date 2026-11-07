import Foundation
import SwiftUI

final class GameStore: ObservableObject {
    // MARK: - Navigation & Mode State
    @Published var currentScreen: AppScreen = .menu
    @Published var activeMode: GameMode = .official
    @Published var inputMode: InputMode = .strictTyping

    // MARK: - Continent Filter for Official & Official + Territories (Always resets to "All" on menu entry)
    static let allContinents: [String] = [
        "All", "Europe", "Asia", "Africa", "North America", "South America", "Oceania"
    ]
    @Published var selectedPlayContinent: String = "All"

    // MARK: - Saved Custom Quizzes
    @Published var customQuizzes: [CustomQuizItem] = [] {
        didSet {
            saveCustomQuizzes()
        }
    }
    @Published var activeCustomQuizId: String? = nil

    // MARK: - Draft State for Creating / Editing a Custom Quiz
    @Published var editingCustomQuizId: String? = nil
    @Published var customSelectedIds: Set<String> = []
    @Published var draftQuizName: String = ""
    @Published var draftSuggestionRule: CustomSuggestionRule = .chooseInGame
    @Published var draftTimeLimitSeconds: Int? = nil

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

    // Re-type tracking (so re-typing after a wrong answer never changes the top counters)
    @Published var isRetypingCurrentCard: Bool = false
    private var currentTurnScored: Bool = false
    private var currentTurnWasCorrectOnFirstSubmission: Bool = false

    // Per-Country Countdown Timer (Custom Mode)
    @Published var remainingTimeSeconds: Int? = nil
    private var questionTimer: Timer? = nil

    // Storage Keys
    private static let customQuizzesKey = "geogame_custom_quizzes_v2"
    private static let legacyCustomSelectionKey = "geogame_custom_selected_country_ids_v1"
    private static let lastAccuracyKey = "geogame_last_accuracy_by_mode_v1"

    init() {
        self.inputMode = .strictTyping

        if let savedScores = UserDefaults.standard.dictionary(forKey: Self.lastAccuracyKey) as? [String: Int] {
            self.lastAccuracyByMode = savedScores
        } else {
            self.lastAccuracyByMode = [:]
        }

        if let data = UserDefaults.standard.data(forKey: Self.customQuizzesKey),
           let decoded = try? JSONDecoder().decode([CustomQuizItem].self, from: data) {
            self.customQuizzes = decoded
        } else if let legacyIds = UserDefaults.standard.stringArray(forKey: Self.legacyCustomSelectionKey),
                  !legacyIds.isEmpty {
            let migrated = CustomQuizItem(
                name: "My Custom Quiz",
                countryIds: legacyIds,
                suggestionRule: .chooseInGame,
                timeLimitSeconds: nil
            )
            self.customQuizzes = [migrated]
            saveCustomQuizzes()
        } else {
            self.customQuizzes = []
        }
    }

    // MARK: - Computed Properties
    var currentCountry: CountryItem? {
        remainingQueue.first
    }

    var activeCustomQuiz: CustomQuizItem? {
        guard activeMode == .custom, let id = activeCustomQuizId else { return nil }
        return customQuizzes.first(where: { $0.id == id })
    }

    var canToggleSuggestionsInGame: Bool {
        if activeMode == .custom, let quiz = activeCustomQuiz {
            return quiz.suggestionRule == .chooseInGame
        }
        return true
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

    var displayedProgressCount: Int {
        let bonus = (submissionState.isCorrect && currentTurnWasCorrectOnFirstSubmission) ? 1 : 0
        return min(totalCardsInRound, completedCount + bonus)
    }

    var roundProgressFraction: Double {
        guard totalCardsInRound > 0 else { return 0 }
        return Double(displayedProgressCount) / Double(totalCardsInRound)
    }

    func countryCount(forContinent continent: String, in mode: GameMode) -> Int {
        let basePool: [CountryItem]
        switch mode {
        case .official:
            basePool = CountryDatabase.officialCountries
        case .officialAndTerritories:
            basePool = CountryDatabase.allItems
        case .custom:
            basePool = CountryDatabase.allItems
        }
        if continent == "All" {
            return basePool.count
        }
        return basePool.filter { $0.continent == continent }.count
    }

    // MARK: - Custom Quizzes Persistence & CRUD
    private func saveCustomQuizzes() {
        if let data = try? JSONEncoder().encode(customQuizzes) {
            UserDefaults.standard.set(data, forKey: Self.customQuizzesKey)
        }
    }

    func openCustomList() {
        HapticsHelper.impact(.light)
        stopQuestionTimer()
        activeMode = .custom
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .customList
        }
    }

    func startCreatingNewCustomQuiz() {
        HapticsHelper.impact(.medium)
        editingCustomQuizId = nil
        customSelectedIds.removeAll()
        draftQuizName = ""
        draftSuggestionRule = .chooseInGame
        draftTimeLimitSeconds = nil
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .customPicker
        }
    }

    func startEditingCustomQuizCountries(_ quiz: CustomQuizItem) {
        HapticsHelper.impact(.light)
        editingCustomQuizId = quiz.id
        customSelectedIds = Set(quiz.countryIds)
        draftQuizName = quiz.name
        draftSuggestionRule = quiz.suggestionRule
        draftTimeLimitSeconds = quiz.timeLimitSeconds
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .customPicker
        }
    }

    func updateCustomQuizMetadata(
        id: String,
        name: String,
        suggestionRule: CustomSuggestionRule,
        timeLimitSeconds: Int?
    ) {
        guard let idx = customQuizzes.firstIndex(where: { $0.id == id }) else { return }
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        customQuizzes[idx].name = cleanName.isEmpty ? "Custom Quiz" : cleanName
        customQuizzes[idx].suggestionRule = suggestionRule
        customQuizzes[idx].timeLimitSeconds = timeLimitSeconds
        HapticsHelper.notification(.success)
    }

    func deleteCustomQuiz(id: String) {
        HapticsHelper.notification(.warning)
        customQuizzes.removeAll { $0.id == id }
        if activeCustomQuizId == id {
            activeCustomQuizId = nil
        }
    }

    func saveDraftCustomQuiz(
        name: String,
        suggestionRule: CustomSuggestionRule,
        timeLimitSeconds: Int?,
        andPlay: Bool
    ) {
        let sortedIds = Array(customSelectedIds).sorted()
        guard !sortedIds.isEmpty else { return }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? "Custom Quiz \(customQuizzes.count + 1)" : trimmedName

        let savedQuiz: CustomQuizItem
        if let editId = editingCustomQuizId,
           let idx = customQuizzes.firstIndex(where: { $0.id == editId }) {
            customQuizzes[idx].name = finalName
            customQuizzes[idx].countryIds = sortedIds
            customQuizzes[idx].suggestionRule = suggestionRule
            customQuizzes[idx].timeLimitSeconds = timeLimitSeconds
            savedQuiz = customQuizzes[idx]
        } else {
            let newQuiz = CustomQuizItem(
                name: finalName,
                countryIds: sortedIds,
                suggestionRule: suggestionRule,
                timeLimitSeconds: timeLimitSeconds
            )
            customQuizzes.append(newQuiz)
            savedQuiz = newQuiz
        }

        HapticsHelper.notification(.success)

        if andPlay {
            playCustomQuiz(savedQuiz)
        } else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                currentScreen = .customList
            }
        }
    }

    func playCustomQuiz(_ quiz: CustomQuizItem) {
        HapticsHelper.impact(.medium)
        activeMode = .custom
        activeCustomQuizId = quiz.id
        startRound(for: .custom)
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
    }

    func selectAll(from items: [CountryItem]) {
        HapticsHelper.impact(.medium)
        for item in items {
            customSelectedIds.insert(item.id)
        }
    }

    func deselectAll(from items: [CountryItem]) {
        HapticsHelper.impact(.light)
        for item in items {
            customSelectedIds.remove(item.id)
        }
    }

    // MARK: - Starting & Managing Rounds
    func selectModeFromMenu(_ mode: GameMode) {
        HapticsHelper.impact(.medium)
        activeMode = mode

        switch mode {
        case .official, .officialAndTerritories:
            // Always start with "All" continents when entering from the menu
            selectedPlayContinent = "All"
            startRound(for: mode)
        case .custom:
            openCustomList()
        }
    }

    func selectInGameContinent(_ continent: String) {
        guard activeMode == .official || activeMode == .officialAndTerritories else { return }
        HapticsHelper.impact(.medium)
        selectedPlayContinent = continent
        startRound(for: activeMode)
    }

    func startRound(for mode: GameMode) {
        stopQuestionTimer()
        activeMode = mode

        let pool: [CountryItem]
        switch mode {
        case .official:
            if selectedPlayContinent == "All" {
                pool = CountryDatabase.officialCountries
            } else {
                pool = CountryDatabase.officialCountries.filter { $0.continent == selectedPlayContinent }
            }
            inputMode = .strictTyping
        case .officialAndTerritories:
            if selectedPlayContinent == "All" {
                pool = CountryDatabase.allItems
            } else {
                pool = CountryDatabase.allItems.filter { $0.continent == selectedPlayContinent }
            }
            inputMode = .strictTyping
        case .custom:
            guard let quiz = activeCustomQuiz else {
                currentScreen = .customList
                return
            }
            let idSet = Set(quiz.countryIds)
            pool = CountryDatabase.allItems.filter { idSet.contains($0.id) }
            switch quiz.suggestionRule {
            case .chooseInGame, .withoutSuggestions:
                inputMode = .strictTyping
            case .withSuggestions:
                inputMode = .suggestions
            }
        }

        guard !pool.isEmpty else {
            if mode == .custom {
                currentScreen = .customList
            }
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

        isRetypingCurrentCard = false
        currentTurnScored = false
        currentTurnWasCorrectOnFirstSubmission = false

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .playing
        }

        startQuestionTimerIfNeeded()
    }

    func restartCurrentMode() {
        HapticsHelper.impact(.medium)
        startRound(for: activeMode)
    }

    func returnToMenu() {
        HapticsHelper.impact(.light)
        stopQuestionTimer()
        typedText = ""
        submissionState = .none
        selectedPlayContinent = "All"
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentScreen = .menu
        }
    }

    // MARK: - Per-Country Timer (Custom Mode)
    func startQuestionTimerIfNeeded() {
        stopQuestionTimer()
        guard activeMode == .custom,
              let quiz = activeCustomQuiz,
              let limit = quiz.timeLimitSeconds,
              limit > 0,
              !submissionState.isSubmitted,
              !isRetypingCurrentCard else {
            remainingTimeSeconds = nil
            return
        }

        remainingTimeSeconds = limit
        questionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard !self.submissionState.isSubmitted else {
                self.stopQuestionTimer()
                return
            }
            if let current = self.remainingTimeSeconds {
                if current > 1 {
                    self.remainingTimeSeconds = current - 1
                } else {
                    self.remainingTimeSeconds = 0
                    self.stopQuestionTimer()
                    self.handleTimerExpired()
                }
            }
        }
    }

    func stopQuestionTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }

    private func handleTimerExpired() {
        guard currentCountry != nil, !submissionState.isSubmitted else { return }
        let trimmed = typedText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            // Evaluate whatever the user has written so far!
            submitAnswer(overrideText: trimmed)
        } else {
            giveUpCurrentCard(emptyPlaceholder: "Time's Up")
        }
    }

    // MARK: - Answer Submission & Progression
    func submitAnswer(overrideText: String? = nil) {
        guard let country = currentCountry else { return }
        let rawInput = (overrideText ?? typedText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawInput.isEmpty else { return }

        stopQuestionTimer()

        if let overrideText = overrideText {
            typedText = overrideText
        }

        let check = CountryDatabase.isAnswerCorrect(rawInput, for: country)

        if !currentTurnScored && !isRetypingCurrentCard {
            // First submission on this card appearance — counts towards round stats & top counters
            currentTurnScored = true
            totalAttempts += 1

            let isFirstAttemptForCountry = !answeredCountryIds.contains(country.id)
            answeredCountryIds.insert(country.id)

            if check.isCorrect {
                correctAttempts += 1
                currentTurnWasCorrectOnFirstSubmission = true
                if isFirstAttemptForCountry {
                    firstTryCorrectCount += 1
                }
                HapticsHelper.notification(.success)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    submissionState = .correct(userAnswer: rawInput, matchedCapital: country.capital)
                }
            } else {
                wrongAttempts += 1
                currentTurnWasCorrectOnFirstSubmission = false
                HapticsHelper.notification(.error)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    submissionState = .incorrect(userAnswer: rawInput, correctCapital: country.capital)
                }
            }
        } else {
            // Re-typing after a wrong answer: do NOT change any top counters or scores!
            if check.isCorrect {
                HapticsHelper.notification(.success)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    submissionState = .correct(userAnswer: rawInput, matchedCapital: country.capital)
                }
            } else {
                HapticsHelper.notification(.error)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    submissionState = .incorrect(userAnswer: rawInput, correctCapital: country.capital)
                }
            }
        }
    }

    /// Directly reveal the answer when the user doesn't know the capital (taps the X button next to Check, or timer expires)
    func giveUpCurrentCard(emptyPlaceholder: String = "No Answer") {
        guard let country = currentCountry, !submissionState.isSubmitted else { return }
        stopQuestionTimer()

        let rawInput = typedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayAnswer = rawInput.isEmpty ? emptyPlaceholder : rawInput

        if !currentTurnScored && !isRetypingCurrentCard {
            currentTurnScored = true
            currentTurnWasCorrectOnFirstSubmission = false
            totalAttempts += 1
            wrongAttempts += 1
            answeredCountryIds.insert(country.id)
        }

        HapticsHelper.notification(.error)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            submissionState = .incorrect(userAnswer: displayAnswer, correctCapital: country.capital)
        }
    }

    /// Re-type immediately on the current card (does not change top counters when re-submitted)
    func retryTypingCurrentCard() {
        HapticsHelper.impact(.light)
        stopQuestionTimer()
        isRetypingCurrentCard = true
        withAnimation(.easeInOut(duration: 0.2)) {
            typedText = ""
            submissionState = .none
        }
    }

    /// Put the current country back into the queue to be asked again later in this round ("Ask Again Later")
    func repeatLater() {
        guard !remainingQueue.isEmpty else { return }
        HapticsHelper.impact(.medium)
        stopQuestionTimer()

        let current = remainingQueue.removeFirst()
        repeatLaterIds.insert(current.id)
        repeatQueuedCountTotal += 1

        if remainingQueue.isEmpty {
            remainingQueue.append(current)
        } else if remainingQueue.count <= 3 {
            remainingQueue.append(current)
        } else {
            let minIndex = max(1, remainingQueue.count / 2)
            let insertIndex = Int.random(in: minIndex...remainingQueue.count)
            remainingQueue.insert(current, at: insertIndex)
        }

        isRetypingCurrentCard = false
        currentTurnScored = false
        currentTurnWasCorrectOnFirstSubmission = false

        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            typedText = ""
            submissionState = .none
        }

        startQuestionTimerIfNeeded()
    }

    /// Mark the current country as completed for this round so it won't be asked again ("Next")
    func nextCountry() {
        guard !remainingQueue.isEmpty else { return }
        HapticsHelper.impact(.light)
        stopQuestionTimer()

        let finished = remainingQueue.removeFirst()
        repeatLaterIds.remove(finished.id)
        completedCount += 1

        typedText = ""
        submissionState = .none
        isRetypingCurrentCard = false
        currentTurnScored = false
        currentTurnWasCorrectOnFirstSubmission = false

        if remainingQueue.isEmpty {
            lastAccuracyByMode[activeMode.rawValue] = accuracyPercentage
            UserDefaults.standard.set(lastAccuracyByMode, forKey: Self.lastAccuracyKey)

            if activeMode == .custom,
               let id = activeCustomQuizId,
               let idx = customQuizzes.firstIndex(where: { $0.id == id }) {
                customQuizzes[idx].lastAccuracy = accuracyPercentage
            }

            HapticsHelper.notification(.success)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                currentScreen = .summary
            }
        } else {
            startQuestionTimerIfNeeded()
        }
    }
}
