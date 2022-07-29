//
//  SceneDelegate.swift
//  CrashSample
//
//  Created by Evgenii Kazakov on 28.07.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground

        window.rootViewController = UINavigationController(rootViewController: CrashingController())
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
