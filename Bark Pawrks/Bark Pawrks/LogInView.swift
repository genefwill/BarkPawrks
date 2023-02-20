//
//  ContentView.swift
//  Bark Pawrks
//
//  Created by Amelia Martin on 10/28/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LogInView: View {
    
    @ObservedObject var userModel = UserViewModel()
    @EnvironmentObject var loggedInModel: AuthViewModel

    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var fullname = ""
    @State var create_email = ""
    //@State var mobile = ""
    @State var create_password = ""
    @State var confirm_password = ""
    
    @State var creatingUser = false
    @State var loggingIn = false
    @State var showingAlert = false
    @State var showingPassAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                
                VStack(spacing: 12){
                    Picker(selection: $isLoginMode, label: Text("Picker Here")) {
                        Text("Login")
                            .tag(false)
                        Text("Create Account")
                            .tag(true)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Image("dog-play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    //Log In Page
                    if !isLoginMode{
                        
                        // log in with google
                        Button {
                            handleGoogle()
                        } label: {
                            HStack{
                                Spacer()
                                Image("Google")
                                Spacer()
                            }
                            
                        } .shadow(color: Color("button-shadow-green"), radius: 5)
                        
                        // text fields for log in info
                        TextField("Email ID", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                        
                        // log in button
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login")
                                Spacer()
                            }
                            
                        } .buttonStyle(PrimaryButtonStyle())
                            // alert in case of invalid log in
                            .alert(isPresented: $showingAlert){
                                Alert(title: Text("Incorrect Email or Password"), message: Text("Login Failed due to invalid credentials."), dismissButton: .default(Text("OK")))
                            }
                        
                        
                        
                        NavigationLink(destination: ForgotPasswordView()){
                            // forgot password
                            Text("Forgot Password")
                                .shadow(color: Color("button-shadow-green"), radius: 5)
                            
                        }
    
                    }
                    
                    // create account
                    else{
                        
                        // create account with google
                        Button {
                            handleGoogle()
                        } label: {
                            HStack{
                                Spacer()
                                Image("Google")
                                Spacer()
                            }
                            
                        } .shadow(color: Color("button-shadow-green"), radius: 5)
                        
                        // text fields for create account
                        TextField("Full Name", text: $fullname)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                        TextField("Email", text: $create_email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $create_password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                            .autocapitalization(.none)
                        SecureField("Confirm Password", text: $confirm_password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("text-field-background")))
                            .autocapitalization(.none)
                        
                        // create account button
                        Button {
                           handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create Account")
                                Spacer()
                            }
                            
                        }.buttonStyle(PrimaryButtonStyle())
                        //alert if passwords dont match
                        .alert(isPresented: $showingPassAlert){
                            Alert(title: Text("Passwords Don't Match"), message: Text("Account Creation Failed. Passwords don't match."), dismissButton: .default(Text("OK")))
                            }
                            
                      
                    }
                    
                }
            }
        
                .navigationTitle(isLoginMode ? "Create Account" : "Log In")
        }
        
    }
    
    // on click function for log in or create account 
    private func handleAction() {
        if !isLoginMode{
            print("log in with firebase ")
            loggingIn = true
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print("Error logging in user")
                    // change showingAlert to true so invalid login alert pops up
                    showingAlert = true
                    loggingIn = false
                    return
                }
                switch authResult {
                    case .none:
                        print("Some other error logging in user")
                        loggingIn = false
                        //Show login error popup
                    case .some(_):
                        print("Succesfully signed in user")
                        loggingIn = false
                        loggedInModel.isUserLoggedIn = true
                        guard let userDocId = Auth.auth().currentUser?.uid else { return }
                        loggedInModel.userUid = userDocId
                        //Display Main View (logged in view)
                }
            }
        } else {
            // passwords match
            if create_password != confirm_password{
                showingPassAlert = true
                create_password = ""
                confirm_password = ""
            }else{
                //Create User in Firebase
                creatingUser = true
                Auth.auth().createUser(withEmail: create_email, password: create_password) { authResult, error in
                    guard error == nil else {
                        creatingUser = false
                        return
                    }
                    //Get User's Unique ID from firbase Auth to add to Firestore User database
                    guard let userDocId = Auth.auth().currentUser?.uid else { return }
                    //Add User to Firestore User database
                    userModel.addUsers(docid: userDocId, userid: create_email, name: fullname)
                    loggedInModel.userUid = userDocId
                }
                creatingUser = false
                //view main page after logging in
                loggedInModel.isUserLoggedIn = true
                
            }
        }
          
    }
    
    // on click function for log in or create account w/ google
    private func handleGoogle() {
        if !isLoginMode{
            print("log in using google with firebase ")
            // Call the google login function
            loggedInModel.googleLogIn()
        } else {
            print("Register a new account with google")
        }
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
