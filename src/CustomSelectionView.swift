import SwiftUI

enum CustomFilterCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case selected = "Selected"
    case official = "Official"
    case territories = "Territories"
    case europe = "Europe"
    case asia = "Asia"
    case africa = "Africa"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case oceania = "Oceania"

    var id: String { rawValue }
}

struct CustomSelectionView: View {
    @EnvironmentObject var store: GameStore
    @State private var searchText: String = ""
    @State private var selectedFilter: CustomFilterCategory = .all
    @State private var showResetAlert: Bool = false
    @State private var showSavedToast: Bool = false

    private var filteredItems: [CountryItem] {
        let base = CountryDatabase.allItems.filter { item in
            switch selectedFilter {
            case .all:
                return true
            case .selected:
                return store.customSelectedIds.contains(item.id)
            case .official:
                return !item.isTerritory
            case .territories:
                return item.isTerritory
            case .europe, .asia, .africa, .northAmerica, .southAmerica, .oceania:
                return item.continent == selectedFilter.rawValue
            }
        }

        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedSearch.isEmpty else {
            return base.sorted { $0.name < $1.name }
        }

        return base.filter { item in
            item.name.lowercased().contains(trimmedSearch) ||
            item.capital.lowercased().contains(trimmedSearch) ||
            item.continent.lowercased().contains(trimmedSearch)
        }.sorted { $0.name < $1.name }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Navigation Bar
            HStack(spacing: 12) {
                Button(action: {
                    store.saveCustomSelection()
                    store.returnToMenu()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                        Text("Menu")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.white.opacity(0.1)))
                    .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

                VStack(spacing: 2) {
                    Text("Custom Study List")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("\(store.customSelectedIds.count) capitals saved")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.appCyan)
                }

                Spacer()

                Button(action: {
                    showResetAlert = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.red.opacity(store.customSelectedIds.isEmpty ? 0.15 : 0.3)))
                    .foregroundColor(store.customSelectedIds.isEmpty ? .white.opacity(0.4) : .red)
                }
                .disabled(store.customSelectedIds.isEmpty)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 12)

            // MARK: - Search Field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.5))

                TextField("Search country or capital city...", text: $searchText)
                    .foregroundColor(.white)
                    .disableAutocorrection(true)
                    .autocapitalization(.words)

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 10)

            // MARK: - Filter Chips + Bulk Actions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CustomFilterCategory.allCases) { category in
                        let isSelected = selectedFilter == category
                        Button(action: {
                            HapticsHelper.impact(.light)
                            selectedFilter = category
                        }) {
                            HStack(spacing: 5) {
                                Text(category.rawValue)
                                if category == .selected {
                                    Text("(\(store.customSelectedIds.count))")
                                }
                            }
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 13)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.purple : Color.white.opacity(0.08))
                            )
                            .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)

            // Bulk Selection Bar for Currently Shown Filter
            HStack {
                Text("Showing \(filteredItems.count) countries & capitals")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))

                Spacer()

                Button(action: {
                    store.selectAll(from: filteredItems)
                }) {
                    Text("Add Shown")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.appCyan)
                }
                .buttonStyle(PlainButtonStyle())

                Text("•")
                    .foregroundColor(.white.opacity(0.3))

                Button(action: {
                    store.deselectAll(from: filteredItems)
                }) {
                    Text("Remove Shown")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.orange)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)

            // MARK: - Country & Capital List
            if filteredItems.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 46))
                        .foregroundColor(.white.opacity(0.3))
                    Text(selectedFilter == .selected ? "No countries selected yet" : "No matching countries or capitals")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.75))
                    Text("Tap countries in the list to add them to your custom training set.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredItems) { item in
                            let isSelected = store.customSelectedIds.contains(item.id)
                            Button(action: {
                                store.toggleCustomCountry(item.id)
                            }) {
                                HStack(spacing: 12) {
                                    Text(item.flag)
                                        .font(.system(size: 32))

                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack(spacing: 6) {
                                            Text(item.name)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                                .lineLimit(1)

                                            if item.isTerritory {
                                                Text("Territory")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Capsule().fill(Color.appTeal.opacity(0.3)))
                                                    .foregroundColor(.appTeal)
                                            }
                                        }

                                        HStack(spacing: 5) {
                                            Image(systemName: "building.columns.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.appCyan.opacity(0.85))
                                            Text(item.capital)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.appCyan)
                                            Text("• \(item.continent)")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.45))
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(isSelected ? .green : .white.opacity(0.28))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 11)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(isSelected ? Color.purple.opacity(0.22) : Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(
                                                    isSelected ? Color.purple.opacity(0.75) : Color.white.opacity(0.07),
                                                    lineWidth: 1
                                                )
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }

            // MARK: - Bottom Save & Start Bar
            VStack(spacing: 8) {
                if showSavedToast {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text("Selection saved! Kept even after closing the app.")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .transition(.opacity)
                }

                HStack(spacing: 12) {
                    Button(action: {
                        HapticsHelper.notification(.success)
                        store.saveCustomSelection()
                        withAnimation {
                            showSavedToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation {
                                showSavedToast = false
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save (\(store.customSelectedIds.count))")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white.opacity(0.14))
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        store.saveCustomSelection()
                        store.startRound(for: .custom)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                            Text("Start Training (\(store.customSelectedIds.count))")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    store.customSelectedIds.isEmpty
                                    ? LinearGradient(colors: [Color.gray.opacity(0.35), Color.gray.opacity(0.25)], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.purple, Color.blue], startPoint: .leading, endPoint: .trailing)
                                )
                        )
                        .foregroundColor(.white)
                    }
                    .disabled(store.customSelectedIds.isEmpty)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Color(red: 0.05, green: 0.07, blue: 0.13)
                    .opacity(0.95)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Saved Selection?"),
                message: Text("Are you sure you want to unselect all \(store.customSelectedIds.count) saved countries and capitals?"),
                primaryButton: .destructive(Text("Reset All")) {
                    store.resetCustomSelection()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
