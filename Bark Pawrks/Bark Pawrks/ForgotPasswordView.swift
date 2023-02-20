//
//  ForgotPasswordView.swift
//  Bark Pawrks
//
//  Created by Amelia Martin on 11/13/22.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct ForgotPasswordView: View {
    @State var email = ""
    @State var showingAlert = false
    @State var navLinkActive = false
    var body: some View {
        VStack(spacing: 30){
            Text("Forgot Password")
                .font(.title)
            Image("dog-play")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            Text("Please enter your Email ID and a password reset link will be sent to your email.")
            TextField("Email ID", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            Button {
                if email != ""{
                    Auth.auth().sendPasswordReset(withEmail: email)
                    showingAlert = true
                }
            }label: {
                HStack {
                    Spacer()
                    Text("Send Password Reset Link")
                    Spacer()
                }
            }.buttonStyle(PrimaryButtonStyle())
                .padding(.top, -20)
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("Reset Email Sent"), message: Text("Follow link in email to reset password."), dismissButton: .default(Text("OK")))
                }
            
            Spacer()
            Spacer()
        }
        
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
