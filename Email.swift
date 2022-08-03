//
//  Email.swift
//  DocQuest
//
//  Created by Daniel Madjar on 7/21/22.
//

import UIKit
import SwiftUI

class Email {
    @Published var toAddress: String = ""
    @Published var subject: String = ""
    @Published var messageHeader: String = ""
    @Published var body: String = ""
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(self.body)
                """)
            }
        }
    }
}



