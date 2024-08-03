//
//  TestPhotoEditorFirebaseApp.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct TestPhotoEditorFirebaseApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Start \nFirebase Configure \nWork")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
    }
}

//Version
/*
 
 Version -> no AppDelegate
 
 @main
 struct SwiftUIAppFirebaseApp: App {
     
     init() {
         FirebaseApp.configure()
     }
     
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 }
 
Version -> AppDelegate

 @main
 struct SwiftUIAppFirebaseApp: App {
     
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
     
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 }

 class AppDelegate: NSObject, UIApplicationDelegate {
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         FirebaseApp.configure()
         return true
     }
 }
 
 */
 
