import SwiftUI

struct RoundSummaryView: View {
    @EnvironmentObject var store: GameStore
    @State private var animateRing = false

    private var ringColor: Color {
        if store.accuracyPercentage >= 85 {
            return .green
        } else if store.accuracyPercentage >= 60 {
            return .appCyan
        } else {
            return .orange
        }
    }

    private var headlineText: String {
        if store.accuracyPercentage == 100 {
            return "Flawless Mastery!"
        } else if store.accuracyPercentage >= 85 {
            return "Excellent Job!"
        } else if store.accuracyPercentage >= 65 {
            return "Great Progress!"
        } else {
            return "Round Complete!"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Spacer(minLength: 12)

                // Mode Badge
                HStack(spacing: 6) {
                    Image(systemName: store.activeMode.iconName)
                    Text(store.activeMode.title)
                }
                .font(.caption.weight(.bold))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Capsule().fill(Color.white.opacity(0.1)))
                .foregroundColor(.appCyan)

                // Title
                VStack(spacing: 6) {
                    Text(headlineText)
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)

                    Text("You have completed all \(store.totalCardsInRound) capitals in this round.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.68))
                        .multilineTextAlignment(.center)
                }

                // MARK: - Animated Accuracy Percentage Ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 16)
                        .frame(width: 176, height: 176)

                    Circle()
                        .trim(from: 0, to: animateRing ? CGFloat(store.accuracyPercentage) / 100.0 : 0)
                        .stroke(
                            AngularGradient(
                                colors: [ringColor.opacity(0.75), ringColor, Color.appCyan],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 176, height: 176)
                        .animation(.spring(response: 0.9, dampingFraction: 0.78), value: animateRing)

                    VStack(spacing: 2) {
                        Text("\(store.accuracyPercentage)%")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)

                        Text("ACCURACY")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(ringColor)
                    }
                }
                .padding(.vertical, 6)

                // MARK: - Detailed Breakdown Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    StatBox(
                        title: "Capitals Completed",
                        value: "\(store.totalCardsInRound)",
                        icon: "flag.fill",
                        color: .appCyan
                    )

                    StatBox(
                        title: "First-Try Accuracy",
                        value: "\(store.firstTryAccuracyPercentage)%",
                        icon: "bolt.fill",
                        color: .yellow
                    )

                    StatBox(
                        title: "Correct Answers",
                        value: "\(store.correctAttempts)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )

                    StatBox(
                        title: "Wrong Attempts",
                        value: "\(store.wrongAttempts)",
                        icon: "xmark.circle.fill",
                        color: .red
                    )
                }
                .padding(.horizontal, 18)

                // MARK: - Action Buttons (Play Again vs Main Menu)
                VStack(spacing: 12) {
                    Button(action: {
                        store.restartCurrentMode()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.system(size: 20, weight: .bold))
                            Text("Play Again (Start Over)")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, Color.appCyan.opacity(0.85)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .foregroundColor(.white)
                        .shadow(color: Color.blue.opacity(0.35), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle())

                    if store.activeMode == .custom {
                        Button(action: {
                            store.openCustomList()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checklist")
                                Text("Back to Custom Quizzes")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.purple.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.purple.opacity(0.7), lineWidth: 1)
                                    )
                            )
                            .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Button(action: {
                        store.returnToMenu()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "house.fill")
                            Text("Back to Main Menu")
                        }
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            animateRing = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateRing = true
            }
        }
    }
}

private struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.white)

            Text(title)
                .font(.caption.weight(.medium))
                .foregroundColor(.white.opacity(0.65))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
