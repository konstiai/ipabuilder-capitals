import SwiftUI

struct CustomQuizListView: View {
    @EnvironmentObject var store: GameStore

    @State private var activeMenuQuiz: CustomQuizItem? = nil
    @State private var editingMetadataQuiz: CustomQuizItem? = nil
    @State private var editNameText: String = ""
    @State private var editSuggestionRule: CustomSuggestionRule = .chooseInGame
    @State private var editTimeLimitSeconds: Int? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Navigation Bar
                HStack(spacing: 12) {
                    Button(action: {
                        store.returnToMenu()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .bold))
                            Text("Menu")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.white.opacity(0.1)))
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    VStack(spacing: 2) {
                        Text("Custom Quizzes")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("\(store.customQuizzes.count) saved")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.appCyan)
                    }

                    Spacer()

                    Button(action: {
                        store.startCreatingNewCustomQuiz()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .bold))
                            Text("New")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 14)

                // MARK: - Content Area
                if store.customQuizzes.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.2))
                                .frame(width: 78, height: 78)
                            Image(systemName: "checklist")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.purple)
                        }

                        Text("No Custom Quizzes Yet")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Tap \"+ New\" at the top right to create your own custom training set with specific countries, suggestion rules, and optional time limits.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.65))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 34)

                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(store.customQuizzes) { quiz in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Top Row: Tappable Quiz Title & Play Icon
                                    Button(action: {
                                        store.playCustomQuiz(quiz)
                                    }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color.purple.opacity(0.28))
                                                    .frame(width: 40, height: 40)
                                                Image(systemName: "play.fill")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.white)
                                            }

                                            Text(quiz.name)
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                                .lineLimit(1)

                                            Spacer(minLength: 0)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    // Bottom Row: Info Pills in one single line WITH the Three-Dots button on the right
                                    HStack(spacing: 6) {
                                        Button(action: {
                                            store.playCustomQuiz(quiz)
                                        }) {
                                            HStack(spacing: 6) {
                                                Label("\(quiz.countryIds.count)", systemImage: "flag.fill")
                                                    .font(.system(size: 11, weight: .semibold))
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 5)
                                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                                                    .foregroundColor(.appCyan)

                                                Text(quiz.suggestionRule.shortLabel)
                                                    .font(.system(size: 11, weight: .semibold))
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .padding(.horizontal, 9)
                                                    .padding(.vertical, 5)
                                                    .background(Capsule().fill(Color.white.opacity(0.08)))
                                                    .foregroundColor(.white.opacity(0.85))

                                                Label(quiz.timeLimitLabel, systemImage: "timer")
                                                    .font(.system(size: 11, weight: .semibold))
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 5)
                                                    .background(Capsule().fill(Color.white.opacity(0.08)))
                                                    .foregroundColor(.orange)

                                                Spacer(minLength: 0)
                                            }
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())

                                        // Three dots menu button aligned on the exact same line
                                        Button(action: {
                                            HapticsHelper.impact(.light)
                                            withAnimation(.easeInOut(duration: 0.18)) {
                                                activeMenuQuiz = quiz
                                            }
                                        }) {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 15, weight: .bold))
                                                .frame(width: 34, height: 30)
                                                .background(Capsule().fill(Color.white.opacity(0.1)))
                                                .foregroundColor(.white)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.white.opacity(0.06))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                .stroke(Color.purple.opacity(0.4), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)
                    }
                }
            }

            // MARK: - Three-Dots Options Modal Overlay
            if let menuQuiz = activeMenuQuiz {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            activeMenuQuiz = nil
                        }
                    }

                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(menuQuiz.name)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("\(menuQuiz.countryIds.count) Capitals • \(menuQuiz.timeLimitLabel)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.65))
                        }
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                activeMenuQuiz = nil
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .frame(width: 30, height: 30)
                                .background(Circle().fill(Color.white.opacity(0.12)))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 4)

                    // Option 1: Edit Name & Settings
                    Button(action: {
                        let target = menuQuiz
                        activeMenuQuiz = nil
                        editNameText = target.name
                        editSuggestionRule = target.suggestionRule
                        editTimeLimitSeconds = target.timeLimitSeconds
                        withAnimation(.easeInOut(duration: 0.2)) {
                            editingMetadataQuiz = target
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "pencil")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.appCyan)
                                .frame(width: 24)
                            Text("Edit Name & Settings")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(13)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Option 2: Edit Countries
                    Button(action: {
                        let target = menuQuiz
                        activeMenuQuiz = nil
                        store.startEditingCustomQuizCountries(target)
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "checklist")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.purple)
                                .frame(width: 24)
                            Text("Edit Countries (\(menuQuiz.countryIds.count))")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(13)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Option 3: Delete Custom Quiz
                    Button(action: {
                        let idToDelete = menuQuiz.id
                        withAnimation(.easeInOut(duration: 0.18)) {
                            activeMenuQuiz = nil
                        }
                        store.deleteCustomQuiz(id: idToDelete)
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.red)
                                .frame(width: 24)
                            Text("Delete Custom Quiz")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(13)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.red.opacity(0.16)))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(red: 0.10, green: 0.13, blue: 0.22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.16), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }

            // MARK: - Edit Name & Settings Modal Overlay
            if let editQuiz = editingMetadataQuiz {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            editingMetadataQuiz = nil
                        }
                    }

                CustomQuizConfigDialog(
                    title: "Edit Custom Quiz",
                    quizName: $editNameText,
                    suggestionRule: $editSuggestionRule,
                    timeLimitSeconds: $editTimeLimitSeconds,
                    showSaveAndPlay: false,
                    onSave: {
                        store.updateCustomQuizMetadata(
                            id: editQuiz.id,
                            name: editNameText,
                            suggestionRule: editSuggestionRule,
                            timeLimitSeconds: editTimeLimitSeconds
                        )
                        withAnimation(.easeInOut(duration: 0.18)) {
                            editingMetadataQuiz = nil
                        }
                    },
                    onSaveAndPlay: {},
                    onCancel: {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            editingMetadataQuiz = nil
                        }
                    }
                )
                .padding(.horizontal, 20)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Shared Custom Quiz Configuration Dialog (Name, Suggestions Rule, Time Limit per Country)
struct CustomQuizConfigDialog: View {
    let title: String
    @Binding var quizName: String
    @Binding var suggestionRule: CustomSuggestionRule
    @Binding var timeLimitSeconds: Int?
    let showSaveAndPlay: Bool
    let onSave: () -> Void
    let onSaveAndPlay: () -> Void
    let onCancel: () -> Void

    private let presetTimes: [Int?] = [nil, 5, 10, 15, 20, 30, 45, 60]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with X close button
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.white.opacity(0.12)))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // 1. Quiz Name Input
            VStack(alignment: .leading, spacing: 6) {
                Text("QUIZ NAME")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))

                TextField("Enter quiz name (e.g. Europe Hard)...", text: $quizName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
            }

            // 2. Suggestions Rule Selector
            VStack(alignment: .leading, spacing: 6) {
                Text("SUGGESTIONS MODE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))

                VStack(spacing: 6) {
                    ForEach(CustomSuggestionRule.allCases) { rule in
                        let isSelected = suggestionRule == rule
                        Button(action: {
                            HapticsHelper.impact(.light)
                            suggestionRule = rule
                        }) {
                            HStack {
                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isSelected ? .appCyan : .white.opacity(0.35))
                                Text(rule.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(isSelected ? Color.blue.opacity(0.28) : Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(isSelected ? Color.appCyan.opacity(0.8) : Color.clear, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }

            // 3. Time Limit Per Country
            VStack(alignment: .leading, spacing: 6) {
                Text("TIME PER COUNTRY")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(presetTimes, id: \.self) { option in
                            let isSelected = timeLimitSeconds == option
                            Button(action: {
                                HapticsHelper.impact(.light)
                                timeLimitSeconds = option
                            }) {
                                Text(option == nil ? "Unlimited" : "\(option!)s")
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? Color.orange : Color.white.opacity(0.08))
                                    )
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }

            // 4. Action Buttons (Save, Save & Play, Cancel)
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    Button(action: onSave) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(showSaveAndPlay ? Color.white.opacity(0.14) : Color.purple)
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())

                    if showSaveAndPlay {
                        Button(action: onSaveAndPlay) {
                            HStack(spacing: 6) {
                                Image(systemName: "play.fill")
                                Text("Save & Play")
                            }
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.purple, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(.white.opacity(0.65))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.09, green: 0.12, blue: 0.21))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 8)
    }
}
