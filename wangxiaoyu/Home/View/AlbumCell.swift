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
    
    var menu = UIMenu()
    
    let moreActionsButton = Tools.setUpButtonWithSystemImage(systemName: "ellipsis", width: 24, height: 8, color: .black)
    
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
            make.top.equalTo(imageView.snp_bottomMargin).offset(18)
        }
        
        containerView.addSubview(moreActionsButton)
        moreActionsButton.snp.makeConstraints { make in
            make.right.equalTo(containerView)
            make.centerY.equalTo(albumTitleLabel)
        }
        
        
        containerView.addSubview(photoNumLabel)
        photoNumLabel.snp.makeConstraints { make in
            make.left.equalTo(albumTitleLabel)
            make.top.equalTo(albumTitleLabel.snp_bottomMargin).offset(12)
        }
        
        setupMenu()
        
        moreActionsButton.menu = menu
        moreActionsButton.showsMenuAsPrimaryAction = true
    }
    
    func setupMenu(){
        let usersItem = UIAction(title: "删除", image: nil, attributes: [.destructive]) { (action) in

            print("Deleting...")
            DBManager.shared.deleteTable(tableName: self.albumTitleLabel.text!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteAlbum"), object: nil)

         }
        
        
        
 
         menu = UIMenu(title: "", options: .displayInline, children: [usersItem])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

