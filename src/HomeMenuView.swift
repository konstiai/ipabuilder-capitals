import SwiftUI

struct HomeMenuView: View {
    @EnvironmentObject var store: GameStore
    @State private var showResetConfirmation = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                // MARK: - Header
                VStack(spacing: 8) {
                    if let logoImage = AppLogoProvider.uiImage {
                        Image(uiImage: logoImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 66, height: 66)
                            .scaleEffect(1.08)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 4)
                            .padding(.top, 8)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.35), Color.appCyan.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 66, height: 66)

                            Image(systemName: "globe")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.appCyan)
                        }
                        .padding(.top, 8)
                    }

                    Text("Capital Trainer")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)

                    Text("Choose a training mode and master world capitals")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.68))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)

                // MARK: - Game Mode Cards
                VStack(spacing: 16) {
                    // Mode 1: Official Capitals
                    ModeCardView(
                        mode: .official,
                        countLabel: "\(CountryDatabase.officialCountries.count) Countries",
                        lastAccuracy: store.lastAccuracyByMode[GameMode.official.rawValue]
                    ) {
                        store.selectModeFromMenu(.official)
                    }

                    // Mode 2: Official + Territories
                    ModeCardView(
                        mode: .officialAndTerritories,
                        countLabel: "\(CountryDatabase.allItems.count) Total (\(CountryDatabase.territories.count) Territories)",
                        lastAccuracy: store.lastAccuracyByMode[GameMode.officialAndTerritories.rawValue]
                    ) {
                        store.selectModeFromMenu(.officialAndTerritories)
                    }

                    // Mode 3: Custom Selection
                    CustomModeCardView(
                        selectedCount: store.customSelectedIds.count,
                        lastAccuracy: store.lastAccuracyByMode[GameMode.custom.rawValue],
                        onStart: {
                            store.selectModeFromMenu(.custom)
                        },
                        onEditList: {
                            store.openCustomPicker()
                        },
                        onReset: {
                            showResetConfirmation = true
                        }
                    )
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
        }
        .alert(isPresented: $showResetConfirmation) {
            Alert(
                title: Text("Reset Custom Selection?"),
                message: Text("This will clear all \(store.customSelectedIds.count) saved countries from your custom study list."),
                primaryButton: .destructive(Text("Reset All")) {
                    store.resetCustomSelection()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

// MARK: - Mode Card View (Modes 1 & 2)
private struct ModeCardView: View {
    let mode: GameMode
    let countLabel: String
    let lastAccuracy: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.18))
                            .frame(width: 50, height: 50)

                        Image(systemName: mode.iconName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(mode.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Text(mode.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.82))
                            .multilineTextAlignment(.leading)
                    }
                }

                HStack(spacing: 10) {
                    Label(countLabel, systemImage: "flag.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.black.opacity(0.25)))
                        .foregroundColor(.white)

                    if let accuracy = lastAccuracy {
                        Label("Last Score: \(accuracy)%", systemImage: "chart.bar.fill")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.black.opacity(0.25)))
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: mode.accentColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: mode.accentColors.first?.opacity(0.3) ?? .clear, radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Mode Card View (Mode 3)
private struct CustomModeCardView: View {
    let selectedCount: Int
    let lastAccuracy: Int?
    let onStart: () -> Void
    let onEditList: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: onStart) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white.opacity(0.18))
                                .frame(width: 50, height: 50)

                            Image(systemName: GameMode.custom.iconName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(GameMode.custom.title)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: selectedCount > 0 ? "play.circle.fill" : "plus.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.white.opacity(0.9))
                            }

                            Text(GameMode.custom.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.82))
                                .multilineTextAlignment(.leading)
                        }
                    }

                    HStack(spacing: 8) {
                        Label(
                            selectedCount == 0 ? "No capitals selected yet" : "\(selectedCount) Saved in List",
                            systemImage: "bookmark.fill"
                        )
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.black.opacity(0.28)))
                        .foregroundColor(.white)

                        if let accuracy = lastAccuracy {
                            Label("Last Score: \(accuracy)%", systemImage: "chart.bar.fill")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.black.opacity(0.28)))
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            if selectedCount > 0 {
                Divider()
                    .background(Color.white.opacity(0.25))

                // Action Buttons for Custom Selection (only shown once capitals are selected)
                HStack(spacing: 10) {
                    Button(action: onStart) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                            Text("Start (\(selectedCount))")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white))
                        .foregroundColor(Color(red: 0.35, green: 0.14, blue: 0.68))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: onEditList) {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                            Text("Add / Edit")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.2))
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: onReset) {
                        HStack(spacing: 5) {
                            Image(systemName: "trash.fill")
                            Text("Reset")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.red.opacity(0.32))
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: GameMode.custom.accentColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: GameMode.custom.accentColors.first?.opacity(0.3) ?? .clear, radius: 10, x: 0, y: 5)
    }
}
