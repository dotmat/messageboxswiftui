//
//  AppView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/8/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

// App View is the master container.

import Foundation
import SwiftUI

struct AppView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection){
            // Numbers View
            //Text("Numbers")
            MessageBoxNumbersView(username: "mathewjenkinson", userToken: "mathew1323")
                .font(.title)
                .tabItem {
                    VStack{
                        Image("smallHashIcon")
                        Text("Numbers")
                    }
                }
                .tag(0)
            
            // Call History View
            Text("Call History")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("smallHistoryIcon")
                        Text("Call History")
                    }
                }
                .tag(1)
            
            // Dialler View
            Text("Dialler")
            .font(.title)
            .tabItem {
                VStack {
                    Image("smallPhoneIcon")
                    Text("Dialler")
                }
            }
            .tag(2)
            
            // Voicemail View
//            Text("Voicemail")
//            .font(.title)
//            .tabItem {
//                VStack {
//                    Image(systemName: "phone.circle")
//                    Text("Voicemail")
//                }
//            }
//            .tag(2)
            
            // Chats View
            Text("Chats")
            .font(.title)
            .tabItem {
                VStack {
                    Image("smallChatIcon")
                    Text("Chats")
                }
            }
            .tag(3)
            
            // Settings View
            Text("Settings")
            .font(.title)
            .tabItem {
                VStack {
                    Image("smallSettingsIcon")
                    Text("Settings")
                }
            }
            .tag(4)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
