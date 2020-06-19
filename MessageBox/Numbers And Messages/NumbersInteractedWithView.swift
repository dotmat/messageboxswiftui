//
//  NumbersInteractedWithView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/11/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

struct InteractedWithNumbersResponse: Decodable, Hashable {
    var success: Bool
    var response: InteractedNumber
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case response = "Response"
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.success = try container.decode(Bool.self, forKey: .success)
      self.response = try container.decode(UserNumber.self, forKey: .response)
    }
}


struct InteractedNumber: Decodable, Hashable {
    var username: String
    var interactions: [InboundNumber]

    enum CodingKeys: String, CodingKey {
      case username = "Username"
      case numbers = "Numbers"
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.username = try container.decode(String.self, forKey: .username)
      self.interactions = try container.decode([InboundNumber].self, forKey: .numbers)
    }
}

struct InboundNumber: Decodable, Hashable {
    var number: String
    var formatted: String
    var isoCode: String

    enum CodingKeys: String, CodingKey {
      case number = "PhoneNumber"
      case formatted = "FormattedNumber"
      case countryCode = "ISOCountryCode"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.formatted = try container.decode(String.self, forKey: .formatted)
        self.isoCode = try container.decode(String.self, forKey: .countryCode)
    }
}

var interactedWithNumbersArray = [MessageBoxNumber]()

struct NumbersInteractedWithView: View {
    @State private var editMode = EditMode.inactive
    @State var shouldAnimate: Bool = false

    var reachability: NetworkReachabilityManager!
    
    let username: String
    let userToken: String
    let usersMessageBoxNumber: String
    
    var body: some View {
//        if(self.shouldAnimate){
//            ActivityIndicator(shouldAnimate: self.$shouldAnimate)
//            Text("Fetching Data...")
//        } else {
//            List{
//                //Text("Words")
//                ForEach(interactedWithNumbersArray){ messageBoxRow in
//                    //MessageBoxNumberRow(mbNumber: messageBoxRow.e164Number)
//                    MessageBoxNumberRow(mbNumber: messageBoxRow)
//
//                }
//                .onDelete(perform: onDelete)
//                .onMove(perform: onMove)
//            }
//        }
//        .navigationBarTitle("Interacted With You", displayMode: .inline)
//        .navigationBarItems(trailing: sendNewMessageButtonFromInteractedView)
        List {
            ForEach(interactedWithNumbersArray){ interactedWithNumberRow in
                NavigationLink(destination: SMSMessageConversationView(username: self.username, userToken: self.userToken, usersMessageBoxNumber: self.usersMessageBoxNumber, externalNumber: "001")){
                    MessageBoxNumberRow(mbNumber: interactedWithNumberRow)
                }
            }
        }
        .navigationBarTitle("Interacted With You", displayMode: .inline)
        .navigationBarItems(trailing: sendNewMessageButtonFromInteractedView)
        .onAppear(){
            print("Getting Interactions View Data")
            self.shouldAnimate = true

            let interactionsObject: [String:String] = [
                "Username": self.username,
                "UserToken": self.userToken,
                "PhoneNumber": self.usersMessageBoxNumber
            ]
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Application":"MessageBoxSwiftUI",
                "BundleID": Bundle.main.bundleIdentifier! as String
            ]

            AF.request("https://api.messagebox.im/V2/UserServices/GetUserNumberInteractions.php?provider=Cognito&mobile=true", method: .post, parameters: interactionsObject, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseDecodable(of: InteractedWithNumbersResponse.self){(response) in
                guard let interactions = response.value else {return}
                print(interactions)
            }
        }
    }

    
    
    private var sendNewMessageButtonFromInteractedView: some View {
        return AnyView(Button(action: sendNewMessageFromInteractedView) { Image(systemName: "plus") })
    }
    
    func sendNewMessageFromInteractedView() {
    }
    
    private func onDelete(offsets: IndexSet) {
    }
    
    private func onLongPress(){
        
    }

    private func onMove(source: IndexSet, destination: Int) {
        messageBoxNumbersArray.move(fromOffsets: source, toOffset: destination)
    }
}

struct NumbersInteractedWithView_Previews: PreviewProvider {
    static var previews: some View {
        NumbersInteractedWithView(username: "mathewjenkinson", userToken: "abc123", usersMessageBoxNumber: "Hello")
    }
}


