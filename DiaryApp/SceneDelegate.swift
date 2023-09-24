//
//  SceneDelegate.swift
//  DiaryApp
//
//  Created by 김하은 on 2023/09/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // Tab Bar Controller 생성
        let tabBarController = UITabBarController()

        // 각 탭에 해당하는 뷰 컨트롤러들 생성
        let viewController1 = ViewController()
        let viewController2 = StarViewController()

        // "+" 버튼 생성
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: viewController1, action: #selector(viewController1.openWriteDiaryViewController))

        // viewController1을 UINavigationController로 래핑
        let navigationController1 = UINavigationController(rootViewController: viewController1)
        navigationController1.navigationBar.prefersLargeTitles = true
        navigationController1.topViewController?.navigationItem.rightBarButtonItem = addButton

        // Tab Bar 아이템 설정
        viewController1.tabBarItem = UITabBarItem(title: "일기장", image: UIImage(systemName: "folder"), tag: 0)
        viewController2.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "star"), tag: 1)

        // 뷰 컨트롤러들을 Tab Bar Controller에 연결
        tabBarController.viewControllers = [navigationController1, viewController2]

        // Tab Bar Controller를 Root View Controller로 설정
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.window = window
        self.tabBarController = tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

