//
//  ViewController.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit
import CardTabBar
class ViewController: CardTabBarController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tabBar.frame.size.height = 800
        tabBar.frame.origin.y = view.frame.height - 800
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(named: "backgroundColor")
        let homeVC = HomeViewController()
        let memoVC = MemoriesViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem.init(title: "相册", image: UIImage(systemName: "heart.circle")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "heart.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)

        
        memoVC.tabBarItem = UITabBarItem.init(title: "回忆", image: UIImage(systemName: "moon.circle")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        memoVC.tabBarItem.selectedImage = UIImage(systemName: "moon.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)
        

        settingsVC.tabBarItem = UITabBarItem.init(title: "设置", image: UIImage(systemName: "gearshape.circle")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(UIColor.init(named: "tabItemColor")!), tag: 0)
        settingsVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(K.appBlue)
        
     
        

//
//
//
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: self.tabBar.bounds.minY , width: self.tabBar.bounds.width - 300, height: self.tabBar.bounds.height + 5), cornerRadius: (self.tabBar.frame.width/2)).cgPath
//
//        layer.opacity = 1.0
//        layer.isHidden = false
//        layer.masksToBounds = false
//        layer.fillColor = color.cgColor
//
//        self.tabBar.layer.insertSublayer(layer, at: 0)
//
//        if let items = self.tabBar.items {
//          items.forEach { item in item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0) }
//        }
//
        self.tabBar.itemWidth = 90
        

        
        tabBar.unselectedItemTintColor =  UIColor.init(named: "tabItemColor")
        UITabBar.appearance().barTintColor = UIColor.init(named: "tabItemColor")
        
        
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tabBarAppearance.backgroundColor = UIColor.init(named: "backgroundColor")
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        
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

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60 // adjust your size here
        return sizeThatFits
    }
}
