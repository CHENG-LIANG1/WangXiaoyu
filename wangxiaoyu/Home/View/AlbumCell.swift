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
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    
    let moreActionsButton = Tools.setUpButtonWithSystemImage(systemName: "ellipsis", width: 30, height: 30, color: .black)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 10
        
    
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
    
//        contentView.addShadow(opacity: 0.8, radius: 19, width: 2.0, height: 2.0, color: .black)
//
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
        }
        Tools.setHeight(imageView, Float(imageWidth))
        
        contentView.addSubview(albumTitleLabel)
        albumTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(8)
            make.top.equalTo(imageView.snp_bottomMargin).offset(8)
        }
        
        contentView.addSubview(photoNumLabel)
        photoNumLabel.snp.makeConstraints { make in
            make.left.equalTo(albumTitleLabel.snp_rightMargin).offset(8)
            make.top.equalTo(imageView.snp_bottomMargin).offset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

