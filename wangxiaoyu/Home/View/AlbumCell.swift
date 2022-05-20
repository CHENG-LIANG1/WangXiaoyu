//
//  AlbumCell.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/20.
//

import UIKit

class AlbumCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    let imageView = UIImageView()
    let imageWidth =  Int(K.screenWidth - 64) / 3
    
    let albumTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    let photoNumLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    let moreActionsButton = Tools.setUpButtonWithSystemImage(systemName: "ellipsis", width: 30, height: 30, color: .black)
    
    let containerView = UIView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 5
    
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
        }
        Tools.setHeight(imageView, Float(imageWidth))
        
        containerView.addSubview(albumTitleLabel)
        albumTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView)
            make.top.equalTo(imageView.snp_bottomMargin).offset(12)
        }
        
        containerView.addSubview(photoNumLabel)
        photoNumLabel.snp.makeConstraints { make in
            make.left.equalTo(albumTitleLabel)
            make.top.equalTo(albumTitleLabel.snp_bottomMargin).offset(12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

