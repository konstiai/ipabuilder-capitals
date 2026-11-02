import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: GameStore

    var body: some View {
        ZStack {
            // Subtle modern dark/adaptive background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.14),
                    Color(red: 0.09, green: 0.12, blue: 0.21)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            switch store.currentScreen {
            case .menu:
                HomeMenuView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            case .customPicker:
                CustomSelectionView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .playing:
                QuizPlayView()
                    .transition(.opacity)
            case .summary:
                RoundSummaryView()
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .preferredColorScheme(.dark)
    }
}
