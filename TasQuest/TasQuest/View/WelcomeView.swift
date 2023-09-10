//
//  WelcomeView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var isNotAuthed: Bool
    @Binding var appData: AppData
    
    @State private var showAuthenticationView: Bool = false
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
                            Button(action: {
                                showAuthenticationView = true  // ボタンが押されたらモーダルを表示
                            }) {
                                Text("新規登録・ログイン")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
                            }
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
        .fullScreenCover(isPresented: $showAuthenticationView) {  // モーダル表示のための.sheet モディファイア
            AuthenticationView(isNotAuthed: $isNotAuthed, appData: $appData)
            
        }
    }
}
