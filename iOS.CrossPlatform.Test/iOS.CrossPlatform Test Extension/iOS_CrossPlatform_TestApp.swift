//
//  iOS_CrossPlatform_TestApp.swift
//  iOS.CrossPlatform Test Extension
//
//  Created by Arthur Eudeline on 01/05/2021.
//

import SwiftUI

@main
struct iOS_CrossPlatform_TestApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
