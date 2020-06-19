//
//  MessageTypesView.swift
//  MessageBox
//
//  Created by Mathew Jenkinson on 5/12/20.
//  Copyright © 2020 Mathew Jenkinson. All rights reserved.
//

import Foundation
import SwiftUI

// There are 7 message types used by messagebox
// SMS message, IPMessage, Image, Video, File, Voicemail, Raw
// IP and SMS are the same type of text based message

struct Message: Identifiable {
    let type: String
    let direction: String
    let timestamp: Int
    let senderID: String
    let destinationID: String
    let message: String?
    let imageURL: String?
    let thumbnailURL: String?
    let mediaURL: String?
    let deliveryStatus: String
    let delivereyTimestamp: Int
    var id: Int {
      return timestamp
    }
}

struct TextMessageView: View {
    var currentMessage: Message
    var body: some View {
        HStack(alignment: .bottom, spacing: 15, content: {
            if(currentMessage.direction == "Incoming"){
                Text(currentMessage.message!)
                .padding()
                    .background(Color.init(red: 0.8, green: 0.8, blue: 0.8))
                //.background(Color.gray)
                .cornerRadius(30)
            } else {
                Text(currentMessage.message!)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(30)
                
            }
            
        })
    }
}
