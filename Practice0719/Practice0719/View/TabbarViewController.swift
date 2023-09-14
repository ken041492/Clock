//
//  TabbarViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/8/29.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupTabs()
        delegate = self
    }
    
    private func setupTabs() {
        
        let WorldVC = createNav(whit: "世界時間", and: UIImage(systemName: "globe"), vc: WorldClockViewController())
        
        let AlarmVC = createNav(whit: "鬧鐘", and: UIImage(systemName: "alarm.fill"), vc: MainViewController())
        
        let StopWatchVC = createNav(whit: "碼表", and: UIImage(systemName: "stopwatch.fill"), vc: StopWatchViewController())

        let TimeVC = createNav(whit: "計時器", and: UIImage(systemName: "timer"), vc: TimerViewController())
        
        self.setViewControllers([WorldVC, AlarmVC, StopWatchVC, TimeVC], animated: true)
        selectedIndex = 1
    }

    private func createNav(whit title: String, and image:UIImage?,
                           vc:UIViewController) -> UINavigationController {
        
        let NavigationController = UINavigationController(rootViewController: vc)
        NavigationController.tabBarItem.title = title
        NavigationController.tabBarItem.image = image
        return NavigationController
        
    }
}

extension TabbarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {

        if viewController == viewControllers?[0] {
            print("first page")
        }
        if viewController == viewControllers?[1] {
            print("second page")
        }
        if viewController == viewControllers?[2] {
            print("third page")
        }
        if viewController == viewControllers?[3] {
            print("last page")
        }
    }
}
