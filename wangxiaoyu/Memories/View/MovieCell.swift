//
//  MovieCell.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/4/30.
//

import UIKit

class MovieCell: UITableViewCell {
    
    var title: UILabel = {
        var lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        return lbl
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
 
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
