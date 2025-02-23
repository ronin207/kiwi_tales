//
//  DashboardView.swift
//  KiWi
//
//  Created by Takumi Otsuka on 8/10/24.
//

import SwiftUI

struct DashboardView: View {
    @State var selectedIndex: Int = 0
    @Binding var selectedTab: Tabs
    @Binding var showMenu: Bool

    @StateObject var userBooksViewModel = UserBookViewModel()
    @StateObject private var storyViewModel = GenerateStoryViewModel()
    @State private var isBookOpen = false
    @State private var showStoryView = false
    @Namespace private var animation
    
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    showMenu: $showMenu,
                    selectedTab: $selectedTab,
                    headerTitle: "My Books",
                    headerImage: "family_star",
                    headerColor: Color.theme.primary
                )

                GeometryReader { geo in
                    ZStack {
                        // Background Circles
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: isIPad ? geo.size.width * 2.5 : geo.size.width * 2,
                                   height: isIPad ? geo.size.width * 2.5 : geo.size.width * 2)
                            .position(x: geo.size.width / 2,
                                    y: isIPad ? geo.size.height * 1.2 : geo.size.height * 1)

                        Circle()
                            .fill(Color.orange)
                            .frame(width: isIPad ? geo.size.width * 2.2 : geo.size.width * 1.8,
                                   height: isIPad ? geo.size.width * 2.2 : geo.size.width * 1.8)
                            .position(x: geo.size.width / 2,
                                    y: isIPad ? geo.size.height * 1.2 : geo.size.height * 1)

                        // Content
                        VStack {
                            if !userBooksViewModel.books.isEmpty {
                                // Book Carousel
                                BookCarousel(
                                    selectedIndex: $selectedIndex,
                                    books: userBooksViewModel.books
                                )
                                .frame(width: UIScreen.main.bounds.width,
                                      height: isIPad ? 600 : 400)
                                .offset(x: 0)
                                .onTapGesture {
                                    if selectedIndex < userBooksViewModel.books.count {
                                        showStoryView = true
                                    }
                                }
                            } else {
                                Text("No books available")
                                    .nunito(.bold, isIPad ? 36 : 28)
                                    .offset(y: isIPad ? 150 : 100)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .background(Color.theme.background)
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showStoryView) {
            if let selectedBook = userBooksViewModel.books[safe: selectedIndex] {
                BookStoryView(
                    book: selectedBook,
                    showStoryView: $showStoryView
                )
            }
        }
        .onAppear {
            userBooksViewModel.fetchUserBooks()
        }
    }
}


#Preview {
    @Previewable @State var selectedTab: Tabs = .dashboard
    @Previewable @State var showMenu: Bool = false

    return DashboardView(selectedTab: $selectedTab, showMenu: $showMenu)
}
