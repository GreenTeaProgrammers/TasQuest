//
//  AuthenticationView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                // Main Content
                VStack{
                    // App Logo or Title
                    Text("TasQuest")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                    
                    // Sign In Button
                    NavigationLink(destination: SignInEmailView(showSignInView: $showSignInView)) {
                        Text("メールアドレスでサインイン")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Sign Up Button
                    NavigationLink(destination: SignUpEmailView(showSignInView: $showSignInView)) { // Assuming you have a SignUpEmailView
                        Text("メールアドレスで登録")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                }
                .padding()
            }
            .navigationTitle("Sign In")
            .navigationBarHidden(true)
        }
    }
}
