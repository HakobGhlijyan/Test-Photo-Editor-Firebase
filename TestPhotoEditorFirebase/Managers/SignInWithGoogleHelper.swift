//
//  SignInWithGoogleHelper.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInWithGoogleHelper {
    @MainActor
    func singIn() async throws -> GoogleSignInResultModel {
        guard let topzVC = Utilities.shared.topViewController() else {
            throw URLError(.unknown)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topzVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.unknown)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(
            idToken: idToken,
            accessToken: accessToken,
            name: name,
            email: email
        )
        
        return tokens
    }
}
