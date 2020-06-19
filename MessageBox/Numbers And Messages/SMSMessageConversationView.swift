//
//  SMSMessageConversationView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/18/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//struct Message: Identifiable {
//    let type: String
//    let direction: String
//    let timestamp: Int
//    let senderID: String
//    let destinationID: String
//    let message: String?
//    let imageURL: String?
//    let thumbnailURL: String?
//    let mediaURL: String?
//    let deliveryStatus: String
//    let delivereyTimestamp: Int
//    var id: Int {
//      return timestamp
//    }
//}

struct MessageRow: View {
    var rowData: Message
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        
        Group {
            if(rowData.direction == "Incoming"){
                if(rowData.type == "SMS" || rowData.type == "IPMessage"){
                    //Text(rowData.message!).foregroundColor(Color.white).background(Color.blue).multilineTextAlignment(.leading)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rowData.senderID).font(.headline)
                            Text(rowData.message!)
                                .font(.subheadline)
                        }
                        .padding(.all, 10.0)
                        .foregroundColor(Color.white)
                        .background(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1))
                        .cornerRadius(15)
                    }
                    Spacer()
                }
                else if(rowData.type == "IMAGE"){
                    //Text(rowData.imageURL!)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rowData.senderID).font(.headline)
                            AsyncImage(
                                url: URL(string: rowData.imageURL!)!,
                                cache: self.cache,
                                placeholder: Text("Loading ..."),
                                configuration: { $0.resizable() }
                            ).scaledToFit()
                            
                        }
                        .padding(.all, 10.0)
                        .foregroundColor(Color.white)
                        .background(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1))
                        .cornerRadius(15)
                    }
                    Spacer()
                }
                else {
                    Text("A message error occurred")
                    
                }
            } else {
                 if(rowData.type == "SMS" || rowData.type == "IPMessage"){
                    //Text(rowData.message!).foregroundColor(Color.white).multilineTextAlignment(.trailing).lineLimit(nil).background(Color.green)
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rowData.senderID).font(.headline)
                            Text(rowData.message!)
                                .font(.subheadline)
                        }
                        .padding(.all, 10.0)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(15)
                    }
                 }
                 else if(rowData.type == "IMAGE"){
                    //Text(rowData.imageURL!)
                    Spacer()
                    HStack {
                        VStack(alignment: .trailing) {
                            Text(rowData.senderID).font(.headline)
                            //Text(rowData.imageURL!).font(.subheadline)
                            Image("user2").scaledToFill()
                                //.resizable().aspectRatio(contentMode: .fit)
                            
                        }
                        .padding(.all, 10.0)
                        .foregroundColor(Color.white)
                        .background(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1))
                        .cornerRadius(15)
                    }
                 }
                else {
                    Text("A message error occurred")
                        .multilineTextAlignment(.trailing)
                    
                }
            }
        }
    }
}


struct SMSMessageConversationView: View {
    var chatMessageArray = [
        Message(type: "SMS", direction: "Incoming", timestamp: 1589463871, senderID: "+16785997538", destinationID: "+14046206007", message: "This is an inbound message", imageURL: nil, thumbnailURL: nil, mediaURL: nil, deliveryStatus: "Delivered", delivereyTimestamp: 1589463871),
        Message(type: "SMS", direction: "Outbound", timestamp: 1589467569, senderID: "+14046206007", destinationID: "+16785997538", message: "This is my outgoing Messsage", imageURL: nil, thumbnailURL: nil, mediaURL: nil, deliveryStatus: "Delivered", delivereyTimestamp: 1589467569),
        Message(type: "IMAGE", direction: "Incoming", timestamp: 1589485467, senderID: "+16785997538", destinationID: "+14046206007", message: nil, imageURL: "https://www.ocdreefs.com/wp-content/uploads/2017/08/neptune-grouper.jpg", thumbnailURL: "https://www.ocdreefs.com/wp-content/uploads/2017/08/neptune-grouper.jpg", mediaURL: nil, deliveryStatus: "Delivered", delivereyTimestamp: 1589485467),
        Message(type: "IPMessage", direction: "Incoming", timestamp: 1589833381, senderID: "Mathew", destinationID: "Craig", message: "Help me Obi One, your my only help!", imageURL: nil, thumbnailURL: nil, mediaURL: nil, deliveryStatus: "Delivered", delivereyTimestamp: 1589833381)
    ]
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var typingMessage: String = ""
    @State var inputTextString: String = "Message..."
    
    let username: String
    let userToken: String
    let usersMessageBoxNumber: String
    let externalNumber: String
    
    @State var shouldAnimate: Bool = false
    
    var body: some View {
        //Text("Some Words")
        VStack{
            List(chatMessageArray){chatMessageRow in
                HStack{
                    //Text(chatMessageRow.senderID)
                    MessageRow(rowData: chatMessageRow)
                }
            }
            MessageInputBar(senderID: usersMessageBoxNumber, destinationID: externalNumber)
            .frame(minHeight: CGFloat(50)).padding()
            .navigationBarTitle("Messaging With", displayMode: .inline)
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ?
            .leading: .bottom)
        }
    }
}

struct SMSMessageConversationView_Previews: PreviewProvider {
    static var previews: some View {
        SMSMessageConversationView(username: "mathew", userToken: "abc123", usersMessageBoxNumber: "Hello", externalNumber: "abc123")
    }
}
