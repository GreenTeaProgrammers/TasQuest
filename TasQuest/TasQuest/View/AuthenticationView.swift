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
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationStack{
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
