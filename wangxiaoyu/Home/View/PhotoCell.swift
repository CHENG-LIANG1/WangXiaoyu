//
//  File.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit

class PhotoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    let imageView = UIImageView()
    


    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}