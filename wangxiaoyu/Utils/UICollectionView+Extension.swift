//
//  UICollectionView+Extension.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/7/23.
//

import Foundation
import UIKit

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
