//
//  Session.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/8/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct User {
    var Username: String
    var FriendlyName: String?
    var UserIcon: String?
    var LoginJWT: String?
    var RefreshJWT: String?
    var LoggedIn: Bool?

    static let `default` = Self(
        username: "mathewjenkinson",
        friendlyName : "Mathew Jenkinson",
        userIcon: "https://res.cloudinary.com/mbmlabs/image/upload/v1472566635/MessageBoxUsers/mathewjenkinson.png",
        loginJWT: "abc123",
        refreshJWT: "xyz987",
        loggedIn: false
    )

    init(username: String, friendlyName: String?, userIcon: String?, loginJWT: String?, refreshJWT: String?, loggedIn: Bool?) {
        self.Username = username
        self.FriendlyName = friendlyName
        self.UserIcon = userIcon
        self.LoginJWT = loginJWT
        self.RefreshJWT = refreshJWT
        self.LoggedIn = loggedIn
    }
}

class SessionStore : ObservableObject {
    @Published var userLoggedin = false
    @Published var username = "NoUsername"
    @Published var friendlyName = "NoUsername"
    @Published var userIcon = ""
    @Published var loginJWT = ""
    @Published var refreshJWT = ""
    
}
