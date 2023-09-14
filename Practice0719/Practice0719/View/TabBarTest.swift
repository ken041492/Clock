//
//  TabBarTest.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/8/29.
//

import Foundation
import UIKit
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let WorldClockVC = UINavigationController(rootViewController: WorldClockViewController())
        WorldClockVC.title = "世界時鐘"
        WorldClockVC.tabBarItem = UITabBarItem(
            title: "世界時鐘",
            image: UIImage(systemName: "globe"),
            selectedImage: UIImage(systemName: "custom.globe"))
        
        let MainVC = UINavigationController(rootViewController: MainViewController())
        MainVC.tabBarItem = UITabBarItem(
            title: "鬧鐘",
            image: UIImage(systemName: "alarm.fill"),
            selectedImage: UIImage(systemName: "alarm.fill"))
        
        let StopWatchVC = UINavigationController(rootViewController: StopWatchViewController())
        StopWatchVC.tabBarItem = UITabBarItem(
            title: "碼表",
            image: UIImage(systemName: "stopwatch.fill"),
            selectedImage: UIImage(systemName: "stopwatch.fill"))
        
        let TimerVC = UINavigationController(rootViewController: TimerViewController())
        TimerVC.tabBarItem = UITabBarItem(
            title: "計時器",
            image: UIImage(systemName: "timer"),
            selectedImage: UIImage(systemName: "timer"))
        viewControllers = [WorldClockVC, MainVC, StopWatchVC, TimerVC]
        selectedIndex = 1
    }
}
