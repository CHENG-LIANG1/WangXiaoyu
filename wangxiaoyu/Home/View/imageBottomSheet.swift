//
//  imageBottomSheet.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/4/29.
//

import DynamicBottomSheet

class ImageBottomSheet: DynamicBottomSheetViewController{
    

    override func configureView() {
        super.configureView()
        
        let dragButton = Tools.setUpDragHandle(color: UIColor.darkGray, width: 50, height: 12, radius: 6)
        contentView.addSubview(dragButton)
        dragButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
        }
        
        Tools.setHeight(contentView, 300)
        
    }
    
}
