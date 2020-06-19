//
//  LoginView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/8/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    @State var errorMessage = ""
    
    @EnvironmentObject var sessionStore: SessionStore
    let defaults = UserDefaults.standard
    
    func attemptUserLoginRequest(){
        print("Attempt User Login Request")
        print(email)
        print(password)
        
        // Check that username and password fields are not blank
        if(email == "" || password == ""){
            self.errorMessage = "Username or Password can't be blank"
            self.error = true
        } else {
            // Make a request to the login server with the credentials
            
            // On success of a login, write the username to user defaults and the login JWT's to session store
            print("Login Successful, writing credentials to session and User Defaults")
            defaults.set(email, forKey: "username")
            defaults.set("https://res.cloudinary.com/mbmlabs/image/upload/v1472566635/MessageBoxUsers/mathewjenkinson.png", forKey: "iconURL")
            defaults.set("Mathew Jenkinson", forKey: "friendlyName")
            
            sessionStore.username = email
            sessionStore.friendlyName = "Mathew Jenkinson"
            sessionStore.loginJWT = "abc123"
            sessionStore.userLoggedin = true
        }
    }
    

    var body: some View {
        VStack() {
            Text("MessageBox")
                .font(.largeTitle).foregroundColor(Color.white)
                .padding([.top, .bottom], 10)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            Image("BaseLogo")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 25)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: self.$email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {self.attemptUserLoginRequest()}) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 25)
            
            Spacer()
//            HStack(spacing: 0) {
//                Text("Don't have an account? ")
//                Button(action: {}) {
//                    Text("Sign Up")
//                        .foregroundColor(.black)
//                }
//            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: self.$error) {
            Alert(title: Text(self.errorMessage))
        }
        
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
