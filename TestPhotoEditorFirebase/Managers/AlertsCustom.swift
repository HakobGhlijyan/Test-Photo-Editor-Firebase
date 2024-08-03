//
//  AlertsCustom.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 02.08.2024.
//

import SwiftUI

struct AlertsCustom: View {
    @State private var isShowingBasicAlert: Bool = false
    @State private var isShowingEntreValueAlert: Bool = false
    @State private var isShowingLoginAlert: Bool = false
    
    @State private var valueString: String = ""
    
    @State private var error: MyAppError = .noNetwork
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Fetch Data") {
                //
                isShowingBasicAlert = true
            }
            .alert("No Network", isPresented: $isShowingBasicAlert) {
                Button("Try Again") {
                    //
                }
                Button("Delete", role: .destructive) {
                    //
                }
                Button("Cancel", role: .cancel) {
                    //
                }
            } message: {
                Text("No network detected. Connect to WiFi or celular and try again")
            }

            
            Button("Entre Data") {
                isShowingEntreValueAlert = true
            }
            .alert("Entre Value", isPresented: $isShowingEntreValueAlert) {
                TextField("Value", text: $valueString)
                Button("Submit") {
                    
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("Entre the dollar value of your item.")
            }

            
            Button("Log In") {
                error = .invalidUserName
                isShowingLoginAlert = true
            }
            .alert(
                isPresented: $isShowingLoginAlert,
                error: error) { error in
                    if error == .invalidUserName {
                        TextField("UseName", text: $valueString)
                    }
                    Button("Submit") {
                        
                    }
                    Button("Cancel", role: .cancel) {
                        
                    }
                } message: { error in
                    Text(error.failureReason)
                }

            
        }
        .padding()
    }
}

#Preview {
    AlertsCustom()
}


enum MyAppError: LocalizedError {
    case invalidUserName
    case invalidPassword
    case noNetwork
    
    var errorDescription: String? {
        switch self {
        case .invalidUserName:
            "Invalid Username"
        case .invalidPassword:
            "Invalid Password"
        case .noNetwork:
            "No Network Connection"
        }
    }
    
    var failureReason: String {
        switch self {
        case .invalidUserName:
            "The username entered does not exist in our database."
        case .invalidPassword:
            "The password entered for the username is incorrect."
        case .noNetwork:
            "Unable to detect a network connection. Please connect to wi-fi or cellular and try again."
        }
    }
    
    
}
