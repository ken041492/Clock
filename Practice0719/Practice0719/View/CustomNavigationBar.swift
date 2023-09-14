//
//  CustomNavigationBar.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/4.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {
    override var intrinsicContentSize: CGSize {
        // 设置自定义导航栏的高度
        return CGSize(width: UIView.noIntrinsicMetric, height: 100) // 100 是你想要的高度
    }
}
