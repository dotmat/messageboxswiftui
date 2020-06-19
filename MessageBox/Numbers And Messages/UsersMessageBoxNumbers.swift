//
//  UsersMessageBoxNumbers.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/11/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

struct MessageBoxNumber: Identifiable, Hashable {
    let e164Number: String
    let friendlyNumber: String
    let iSOCountryCode: String
    let voiceCapable: Bool
    let smsCapable: Bool
    let mmsCapable: Bool
    let id: String
}

struct VerifiedNumbers: Identifiable, Hashable {
    let formattedNumber: String
    let isoCountryCode: String
    let e164Number: String
    let id: String
}

struct UserNumbersResponse: Decodable, Hashable {
  var success: Bool
  var response: UserNumber
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

struct UserNumber: Decodable, Hashable {
  var username: String
    var phoneNumbers: [PhoneNumber]
  var verifiedNumbers: [PhoneNumber]
    
  enum CodingKeys: String, CodingKey {
    case username = "Username"
    case numbers = "Numbers"
    case verified = "VerifiedNumbers"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.username = try container.decode(String.self, forKey: .username)
    self.phoneNumbers = try container.decode([PhoneNumber].self, forKey: .numbers)
    self.verifiedNumbers = try container.decode([PhoneNumber].self, forKey: .verified)
  }
}

struct PhoneNumber: Decodable, Hashable {
    var number: String
    var formatted: String
    var isoCode: String
    var voiceCapable: Bool = false
    var smsCapable: Bool = false
    var mmsCapable: Bool = false

  enum CodingKeys: String, CodingKey {
    case number = "PhoneNumber"
    case formatted = "FormattedNumber"
    case countryCode = "ISOCountryCode"
    case capabilities
  }

    enum CapabilityCodingKeys: String, CodingKey {
        case voice
        case sms
        case mms
  }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.formatted = try container.decode(String.self, forKey: .formatted)
        self.isoCode = try container.decode(String.self, forKey: .countryCode)

        // If the capabilities are missing, they're assumed false.
        // This could be chagned to be a trinary enum like
        if let capabilities = try? container.nestedContainer(keyedBy: CapabilityCodingKeys.self, forKey: .capabilities) {
            self.voiceCapable = try capabilities.decode(Bool.self, forKey: .voice)
            self.smsCapable = try capabilities.decode(Bool.self, forKey: .sms)
            self.mmsCapable = try capabilities.decode(Bool.self, forKey: .mms)
        }
    }
}


//var testMessageBoxNumbers = [
//    MessageBoxNumber(e164Number: "+16467621007",friendlyNumber: "(646) 762-1007",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+16467621007"),
//    MessageBoxNumber(e164Number: "+14152555613",friendlyNumber: "(415) 255-5613",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+14152555613"),
//    MessageBoxNumber(e164Number: "+14046206007",friendlyNumber: "(404) 620-6007",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+14046206007"),
//    MessageBoxNumber(e164Number: "+14152998007",friendlyNumber: "(415) 299-8007",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+14152998007"),
//    MessageBoxNumber(e164Number: "+14046203820",friendlyNumber: "(404) 620-3820",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+14046203820"),
//    MessageBoxNumber(e164Number: "+15134638431",friendlyNumber: "(513) 463-8431",iSOCountryCode: "US",voiceCapable: true,smsCapable: true,mmsCapable: true, id: "+15134638431"),
//    MessageBoxNumber(e164Number: "+447400341139",friendlyNumber: "07400341139",iSOCountryCode: "GB",voiceCapable: true,smsCapable: true,mmsCapable: false, id: "+447400341139")
//]

var messageBoxNumbersArray = [MessageBoxNumber]()
var verifiedNumbersArray = [VerifiedNumbers]()
//var messageBoxNumbersArray = testMessageBoxNumbers

struct MessageBoxNumbersView: View {
    @State private var editMode = EditMode.inactive
    @State var shouldAnimate: Bool = false
    
    var reachability: NetworkReachabilityManager!
    
    let username: String
    let userToken: String
    
    var body: some View {
        NavigationView {
            if(self.shouldAnimate){
                ActivityIndicator(shouldAnimate: self.$shouldAnimate)
                Text("Fetching Data...")
            } else {
                List{
                    ForEach(messageBoxNumbersArray){ messageBoxRow in
                        //Text(messageBoxRow.id)
                        NavigationLink(destination: NumbersInteractedWithView(username: self.username, userToken: self.userToken, usersMessageBoxNumber: messageBoxRow.id)){
                            MessageBoxNumberRow(mbNumber: messageBoxRow)
                        }
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                }
                .navigationBarTitle("Your Numbers", displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing: addNewNumberButton)
                .environment(\.editMode, $editMode)
            }
        }.onAppear {
            print("Getting Users MessageBox Numbers")
            // Make a request to get the users messagebox numbers from the API
            self.shouldAnimate = true
        
            let loginObject: [String:String] = [
                "Username": self.username,
                "UserToken": self.userToken
            ]
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Application":"MessageBoxSwiftUI",
                "BundleID": Bundle.main.bundleIdentifier! as String
            ]
            
//            AF.request("https://api.messagebox.im/V2/UserServices/GetUsersNumbers.php?provider=Cognito&mobile=true", method: .post, parameters: loginObject, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { response in
//                //debugPrint(response.result)
//                //print(response.result)
//                guard let jsonResponse = response.value else { return }
//                print(jsonResponse)
//
//            }

            AF.request("https://api.messagebox.im/V2/UserServices/GetUsersNumbers.php?provider=Cognito&mobile=true", method: .post, parameters: loginObject, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseDecodable(of: UserNumbersResponse.self){ (response) in
                guard let numbers = response.value else {return}
                print(numbers.response)
                // UserDefaults.standard.set(numbers.response.phoneNumbers, forKey: "MessageBoxNumbers")
                // UserDefaults.standard.set(numbers.response.verifiedNumbers, forKey: "VerifiedNumbers")

                // Put each phone number into the messageBoxNumbersArray as a type of MessageBoxNumber
                for phoneNumberRow in numbers.response.phoneNumbers {
                    //print(phoneNumberRow)
                    messageBoxNumbersArray.append(MessageBoxNumber(e164Number: phoneNumberRow.number, friendlyNumber: phoneNumberRow.formatted, iSOCountryCode: phoneNumberRow.isoCode, voiceCapable: phoneNumberRow.voiceCapable, smsCapable: phoneNumberRow.smsCapable, mmsCapable: phoneNumberRow.mmsCapable, id: phoneNumberRow.number))
                }
                self.shouldAnimate = false
                for verifiedNumberRow in numbers.response.verifiedNumbers {
                    verifiedNumbersArray.append(VerifiedNumbers(formattedNumber: verifiedNumberRow.formatted, isoCountryCode: verifiedNumberRow.isoCode, e164Number: verifiedNumberRow.number, id: verifiedNumberRow.number))
                }
            }


        }
    }
    
    private var addNewNumberButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    func getUsersMessageBoxNumbers(){
        print("Getting Users MessageBox Numbers")
    }
    
    func onAdd() {
    }
    
    private func onDelete(offsets: IndexSet) {
    }

    private func onMove(source: IndexSet, destination: Int) {
        messageBoxNumbersArray.move(fromOffsets: source, toOffset: destination)
    }
}

struct MessageBoxNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBoxNumbersView(username: "mathewjenkinson", userToken: "abc123")
    }
}

struct MessageBoxNumberRow: View {
    let mbNumber: MessageBoxNumber
    var body: some View {
        HStack {
            Image(mbNumber.iSOCountryCode)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipped()
                .cornerRadius(65)
            VStack(alignment: .leading){
                Text(mbNumber.e164Number)
                    .font(.system(size: 21, weight: .medium, design: .default))
                Text(mbNumber.friendlyNumber)
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
