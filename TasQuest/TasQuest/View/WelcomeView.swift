//
//  WelcomeView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI

struct WelcomeView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex) {
                ForEach(pages) { page in
                    VStack {
                        Spacer()
                        PageView(page: page)
                        Spacer()
                        if page == pages.last {
                            NavigationLink(destination: AuthenticationView(showSignInView: .constant(true))) {
                                Text("新規登録・ログイン")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                    }
                    .tag(page.tag)  // Make sure the tag matches with pageIndex
                }
            }
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                dotAppearance.currentPageIndicatorTintColor = .black
                dotAppearance.pageIndicatorTintColor = .gray
            }
        }
    }
}
