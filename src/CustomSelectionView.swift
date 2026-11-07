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

    var isContinent: Bool {
        switch self {
        case .europe, .asia, .africa, .northAmerica, .southAmerica, .oceania:
            return true
        default:
            return false
        }
    }
}

struct CustomSelectionView: View {
    @EnvironmentObject var store: GameStore
    @State private var searchText: String = ""
    @State private var activeFilters: Set<CustomFilterCategory> = []
    @State private var showResetAlert: Bool = false
    @State private var showSaveDialog: Bool = false

    private func isFilterSelected(_ category: CustomFilterCategory) -> Bool {
        if category == .all {
            return activeFilters.isEmpty
        }
        return activeFilters.contains(category)
    }

    private func toggleFilter(_ category: CustomFilterCategory) {
        HapticsHelper.impact(.light)
        if category == .all {
            activeFilters.removeAll()
            return
        }
        if activeFilters.contains(category) {
            activeFilters.remove(category)
        } else {
            activeFilters.insert(category)
        }
    }

    private var filteredItems: [CountryItem] {
        let selectedContinents = Set(activeFilters.filter { $0.isContinent }.map { $0.rawValue })
        let wantsSelectedOnly = activeFilters.contains(.selected)
        let wantsOfficial = activeFilters.contains(.official)
        let wantsTerritories = activeFilters.contains(.territories)

        let base = CountryDatabase.allItems.filter { item in
            if wantsSelectedOnly && !store.customSelectedIds.contains(item.id) {
                return false
            }

            if wantsOfficial && !wantsTerritories && item.isTerritory {
                return false
            }
            if wantsTerritories && !wantsOfficial && !item.isTerritory {
                return false
            }

            if !selectedContinents.isEmpty && !selectedContinents.contains(item.continent) {
                return false
            }

            return true
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
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Navigation Bar
                HStack(spacing: 12) {
                    Button(action: {
                        store.openCustomList()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Back")
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
                        Text(store.editingCustomQuizId == nil ? "New Custom Quiz" : "Edit Custom Quiz")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("\(store.customSelectedIds.count) capitals selected")
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

                // MARK: - Multi-Select Filter Chips (Same design, supports combining e.g. Europe + Official)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(CustomFilterCategory.allCases) { category in
                            let isSelected = isFilterSelected(category)
                            Button(action: {
                                toggleFilter(category)
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
                        Text(activeFilters.contains(.selected) ? "No countries selected yet" : "No matching countries or capitals")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.75))
                        Text("Tap countries in the list or adjust your filters above.")
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

                // MARK: - Bottom Save Bar
                HStack(spacing: 12) {
                    Button(action: {
                        HapticsHelper.impact(.medium)
                        if store.draftQuizName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            store.draftQuizName = "Custom Quiz \(store.customQuizzes.count + 1)"
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showSaveDialog = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save Custom Quiz (\(store.customSelectedIds.count))")
                        }
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
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
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Color(red: 0.05, green: 0.07, blue: 0.13)
                        .opacity(0.95)
                        .ignoresSafeArea(edges: .bottom)
                )
            }

            // MARK: - Save & Configure Custom Quiz Modal
            if showSaveDialog {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            showSaveDialog = false
                        }
                    }

                CustomQuizConfigDialog(
                    title: store.editingCustomQuizId == nil ? "Save Custom Quiz" : "Update Custom Quiz",
                    quizName: $store.draftQuizName,
                    suggestionRule: $store.draftSuggestionRule,
                    timeLimitSeconds: $store.draftTimeLimitSeconds,
                    showSaveAndPlay: true,
                    onSave: {
                        showSaveDialog = false
                        store.saveDraftCustomQuiz(
                            name: store.draftQuizName,
                            suggestionRule: store.draftSuggestionRule,
                            timeLimitSeconds: store.draftTimeLimitSeconds,
                            andPlay: false
                        )
                    },
                    onSaveAndPlay: {
                        showSaveDialog = false
                        store.saveDraftCustomQuiz(
                            name: store.draftQuizName,
                            suggestionRule: store.draftSuggestionRule,
                            timeLimitSeconds: store.draftTimeLimitSeconds,
                            andPlay: true
                        )
                    },
                    onCancel: {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            showSaveDialog = false
                        }
                    }
                )
                .padding(.horizontal, 20)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Selected Capitals?"),
                message: Text("Are you sure you want to unselect all \(store.customSelectedIds.count) selected countries and capitals?"),
                primaryButton: .destructive(Text("Reset All")) {
                    store.resetCustomSelection()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
