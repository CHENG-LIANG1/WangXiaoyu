//
//  ViewController.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit
class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(named: "backgroundColor")
        let homeVC = HomeViewController()
        let memoVC = MemoriesViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem.init(title: "遇记", image: UIImage(systemName: "heart.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "heart.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)

        
        memoVC.tabBarItem = UITabBarItem.init(title: "回忆", image: UIImage(systemName: "moon.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        memoVC.tabBarItem.selectedImage = UIImage(systemName: "moon.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)
        
        

        settingsVC.tabBarItem = UITabBarItem.init(title: "设置", image: UIImage(systemName: "gearshape.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        settingsVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)
        
        tabBar.unselectedItemTintColor =  UIColor.init(named: "tabItemColor")
        UITabBar.appearance().barTintColor = UIColor.init(named: "tabItemColor")
        
        
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "tabItemColor")!]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.appBlue]
        
        tabBarAppearance.backgroundColor = UIColor.init(named: "backgroundColor")
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
        

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false

        
        let controllerArray = [homeVC, memoVC, settingsVC]
        self.viewControllers = controllerArray.map{(UINavigationController.init(rootViewController: $0))}
    }
}
