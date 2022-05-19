//
//  PhotoCollectionViewCell.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/19.
//
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
//        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
