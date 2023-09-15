//
//  WelcomeView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI

/// アプリ起動時のウェルカム画面を表示するView
struct WelcomeView: View {
    
    /// 認証されていないかどうかを表すバインディング変数
    @Binding var isNotAuthed: Bool
    
    /// 認証画面を表示するかどうかを制御するState変数
    @State private var showAuthenticationView: Bool = false
    /// 現在のページインデックス
    @State private var pageIndex = 0
    /// 表示するページの配列
    private let pages: [Page] = Page.samplePages
    /// UIPageControlの外観を制御する
    private let dotAppearance = UIPageControl.appearance()
    
    /// 画面の本体
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex) {
                ForEach(pages) { page in
                    VStack {
                        Spacer()
                        PageView(page: page)
                        Spacer()
                        if page == pages.last {
                            // 最後のページにボタンを表示
                            Button(action: {
                                showAuthenticationView = true  // ボタンが押されたら認証画面を表示
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
                    .tag(page.tag)  // タグはpageIndexと一致する必要がある
                }
            }
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                // ページインジケータの色を設定
                dotAppearance.currentPageIndicatorTintColor = .black
                dotAppearance.pageIndicatorTintColor = .gray
            }
        }
        .fullScreenCover(isPresented: $showAuthenticationView) {  // 認証画面のモーダル表示
            AuthenticationView(isNotAuthed: $isNotAuthed)
        }
    }
}
