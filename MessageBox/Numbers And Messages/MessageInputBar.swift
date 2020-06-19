//
//  MessageInputBar.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/18/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct MessageInputBar: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var typingMessage: String = ""
    @State var inputTextString: String = "Message..."
    var senderID:String
    var destinationID:String
    
    func sendMessage() {
        typingMessage = ""
    }
    func sendMedia(){
        typingMessage = ""
    }
    
    var body: some View {
        HStack {
            Button(action: sendMedia){
                Image(systemName: "paperclip.circle")
            }
            TextField(inputTextString, text: $typingMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minHeight: CGFloat(30))
            Button(action:sendMessage) {
                //Text("Send")
                Image(systemName: "arrow.up.circle").foregroundColor(Color.green)
            }
        }
    }
}



struct MessageInputBar_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputBar(senderID: "Mathew", destinationID: "DotMat")
    }
}
