import SwiftUI

struct QuizPlayView: View {
    @EnvironmentObject var store: GameStore

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Navigation & Progress Header
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    Button(action: {
                        store.returnToMenu()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 34, height: 34)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    // Progress Pill (Centered, shows only X/Total)
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.appCyan)
                        Text("\(store.displayedProgressCount)/\(store.totalCardsInRound)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color.white.opacity(0.08)))

                    Spacer()

                    if store.activeMode == .custom {
                        Button(action: {
                            store.openCustomPicker()
                        }) {
                            Image(systemName: "checklist")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 34, height: 34)
                                .background(Circle().fill(Color.purple.opacity(0.3)))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            store.restartCurrentMode()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 34, height: 34)
                                .background(Circle().fill(Color.white.opacity(0.1)))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                // Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appCyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(6, geo.size.width * CGFloat(store.roundProgressFraction)), height: 6)
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: store.roundProgressFraction)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)
            .padding(.bottom, 8)

            // MARK: - Main Scrollable Quiz Area
            ScrollView(showsIndicators: false) {
                if let country = store.currentCountry {
                    VStack(spacing: 12) {
                        // MARK: - Compact Country & Flag Card
                        VStack(spacing: 6) {
                            HStack {
                                Label(country.continent, systemImage: "globe")
                                    .font(.caption2.weight(.semibold))
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                                    .foregroundColor(.white.opacity(0.85))

                                if country.isTerritory {
                                    Text("Territory")
                                        .font(.caption2.weight(.bold))
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.appTeal.opacity(0.3)))
                                        .foregroundColor(.appTeal)
                                }

                                Spacer()

                                if store.repeatLaterIds.contains(country.id) {
                                    Label("Repeat Card", systemImage: "arrow.triangle.2.circlepath")
                                        .font(.caption2.weight(.bold))
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.orange.opacity(0.25)))
                                        .foregroundColor(.orange)
                                }
                            }

                            Text(country.flag)
                                .font(.system(size: 52))
                                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)

                            VStack(spacing: 2) {
                                Text("COUNTRY / TERRITORY")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white.opacity(0.5))

                                Text(country.name)
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.bottom, 6)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        )

                        // MARK: - Input Box & Submit Button
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Text(store.inputMode == .strictTyping
                                     ? "Write the exact capital city:"
                                     : "Type letters to see capitals:")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.white.opacity(0.75))
                                    .lineLimit(1)

                                Spacer()

                                Button(action: {
                                    HapticsHelper.impact(.light)
                                    withAnimation(.easeInOut(duration: 0.18)) {
                                        store.inputMode = (store.inputMode == .strictTyping) ? .suggestions : .strictTyping
                                    }
                                }) {
                                    HStack(spacing: 5) {
                                        Image(systemName: store.inputMode == .strictTyping ? "sparkles" : "eye.slash.fill")
                                            .font(.system(size: 11, weight: .bold))
                                        Text(store.inputMode == .strictTyping ? "Show Suggestions" : "Hide Suggestions")
                                            .font(.system(size: 12, weight: .bold))
                                    }
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(store.inputMode == .strictTyping ? Color.blue.opacity(0.32) : Color.appCyan.opacity(0.25))
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.appCyan.opacity(0.85), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "building.columns.fill")
                                        .foregroundColor(.white.opacity(0.45))

                                    TextField("Enter capital city...", text: $store.typedText, onCommit: {
                                        if !store.submissionState.isSubmitted {
                                            store.submitAnswer()
                                        }
                                    })
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.words)
                                    .disabled(store.submissionState.isSubmitted)

                                    if !store.typedText.isEmpty && !store.submissionState.isSubmitted {
                                        Button(action: {
                                            store.typedText = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white.opacity(0.45))
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 13)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(borderColorForInputState, lineWidth: 1.5)
                                        )
                                )

                                if !store.submissionState.isSubmitted {
                                    Button(action: {
                                        store.submitAnswer()
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("Check")
                                            Image(systemName: "paperplane.fill")
                                        }
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .fill(
                                                    store.typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                                    ? Color.white.opacity(0.12)
                                                    : Color.blue
                                                )
                                        )
                                        .foregroundColor(.white)
                                    }
                                    .disabled(store.typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    .buttonStyle(PlainButtonStyle())

                                    // X Button to reveal answer directly without typing
                                    Button(action: {
                                        store.giveUpCurrentCard()
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .heavy))
                                            .frame(width: 44, height: 46)
                                            .background(
                                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                    .fill(Color.red.opacity(0.22))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                            .stroke(Color.red.opacity(0.65), lineWidth: 1.2)
                                                    )
                                            )
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }

                            // MARK: - Live Autocomplete Suggestions (when InputMode == .suggestions)
                            if store.inputMode == .suggestions && !store.submissionState.isSubmitted {
                                let suggestions = store.currentSuggestions
                                if !suggestions.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Matching Capitals (tap to select):")
                                            .font(.caption2.weight(.bold))
                                            .foregroundColor(.appCyan)

                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8)
                                            ],
                                            spacing: 8
                                        ) {
                                            ForEach(suggestions, id: \.self) { suggestion in
                                                Button(action: {
                                                    store.submitAnswer(overrideText: suggestion)
                                                }) {
                                                    HStack(spacing: 6) {
                                                        Image(systemName: "mappin.and.ellipse")
                                                            .font(.caption)
                                                            .foregroundColor(.appCyan)
                                                        Text(suggestion)
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(.white)
                                                            .lineLimit(1)
                                                        Spacer(minLength: 0)
                                                    }
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 10)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                                                            .fill(Color.blue.opacity(0.22))
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                                                    .stroke(Color.appCyan.opacity(0.45), lineWidth: 1)
                                                            )
                                                    )
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(.top, 4)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                } else if !store.typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    HStack(spacing: 6) {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.orange)
                                        Text("No capital starts with \"\(store.typedText)\"")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.top, 2)
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        )

                        // MARK: - Answer Feedback & Progression Buttons ("Repeat Later" vs "Next")
                        if store.submissionState != .none {
                            SubmissionFeedbackView(
                                state: store.submissionState,
                                onRetryTyping: {
                                    store.retryTypingCurrentCard()
                                },
                                onRepeatLater: {
                                    store.repeatLater()
                                },
                                onNext: {
                                    store.nextCountry()
                                }
                            )
                            .transition(.scale(scale: 0.96).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var borderColorForInputState: Color {
        switch store.submissionState {
        case .none:
            return Color.white.opacity(0.18)
        case .correct:
            return Color.green
        case .incorrect:
            return Color.red
        }
    }
}

// MARK: - Submission Feedback & Action Buttons View
private struct SubmissionFeedbackView: View {
    let state: SubmissionState
    let onRetryTyping: () -> Void
    let onRepeatLater: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            switch state {
            case .none:
                EmptyView()

            case .correct(_, let matchedCapital):
                // Correct Answer Banner
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.25))
                            .frame(width: 44, height: 44)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.green)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Correct Answer!")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                        Text(matchedCapital)
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.green.opacity(0.14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.green.opacity(0.55), lineWidth: 1.5)
                        )
                )

            case .incorrect(let userAnswer, let correctCapital):
                // Wrong Answer Comparison: User's Answer in Red + Correct Capital right next to it in Green
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.octagon.fill")
                            .foregroundColor(.red)
                        Text("Not quite right — compare below:")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white.opacity(0.85))
                        Spacer()

                        Button(action: onRetryTyping) {
                            HStack(spacing: 4) {
                                Image(systemName: "keyboard")
                                Text("Re-type Now")
                            }
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.white.opacity(0.14)))
                            .foregroundColor(.appCyan)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    // Side-by-side Red (Your Answer) & Green (Correct Capital)
                    HStack(spacing: 10) {
                        // User's wrong answer in RED
                        VStack(alignment: .leading, spacing: 4) {
                            Text("YOUR ANSWER")
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(.red.opacity(0.9))

                            Text(userAnswer)
                                .strikethrough(true, color: Color.red.opacity(0.85))
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.red.opacity(0.18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .stroke(Color.red.opacity(0.65), lineWidth: 1.2)
                                )
                        )

                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white.opacity(0.5))

                        // Correct Capital right next to it in GREEN
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CORRECT CAPITAL")
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(.green.opacity(0.95))

                            Text(correctCapital)
                                .font(.system(size: 17, weight: .heavy, design: .rounded))
                                .foregroundColor(.green)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.green.opacity(0.18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .stroke(Color.green.opacity(0.65), lineWidth: 1.2)
                                )
                        )
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.red.opacity(0.45), lineWidth: 1.2)
                        )
                )
            }

            // MARK: - Action Buttons ("Ask Again Later" vs "Next")
            HStack(spacing: 12) {
                Button(action: onRepeatLater) {
                    HStack(spacing: 7) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 15, weight: .bold))
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Ask Again Later")
                                .font(.system(size: 14, weight: .bold))
                            Text("Repeat in this round")
                                .font(.system(size: 10, weight: .medium))
                                .opacity(0.8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.orange.opacity(0.24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.orange.opacity(0.75), lineWidth: 1.2)
                            )
                    )
                    .foregroundColor(.orange)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: onNext) {
                    HStack(spacing: 7) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Next")
                                .font(.system(size: 15, weight: .bold))
                            Text("Done for this round")
                                .font(.system(size: 10, weight: .medium))
                                .opacity(0.85)
                        }
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.appCyan.opacity(0.85)],
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
    }
}
