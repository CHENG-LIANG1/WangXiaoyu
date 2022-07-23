//
//  File.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit

class PhotoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    let imageView = UIImageView()
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.edges.equalTo(contentView)
        }
        
        
        
//        let coloredView = UIView(frame: bounds)
//        coloredView.backgroundColor = UIColor.red
//        self.selectedBackgroundView = coloredView


    }
    
    func toggoleSelection(){
        if self.isSelected {
            self.imageView.layer.borderWidth = 5
        }else{
            self.imageView.layer.borderWidth = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
