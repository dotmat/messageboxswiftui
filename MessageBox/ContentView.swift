//
//  ContentView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/8/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {

    @EnvironmentObject var sessionStore: SessionStore
    let defaults = UserDefaults.standard
    let username = UserDefaults.standard.string(forKey: "username") ?? "NoUsername"
    
    var body: some View {
        Group {
            if(username == "NoUsername"){
                AuthView()
            } else {
                if(sessionStore.userLoggedin == false){
                    AuthView()
                } else {
                    // Once a user has been logged in, there are a few async events that need to go on.
                    // Load the user profile, this includes the users custom dictory,  usericon and get a Twilio Voice Token so the app can receieve calls.                    
                    AppView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
