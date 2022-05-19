//
//  imageBottomSheet.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/4/29.
//

import DynamicBottomSheet
import UIKit
import SDCAlertView

class ImageBottomSheet: DynamicBottomSheetViewController{
    var tartgetImage: UIImage?
    var selectedImageID: Int?
    private var presentingController: UIViewController?
    @objc func saveCompleted(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
            print("ERROR: \(error)")
        }else {
            self.showToast(message: "已下载", fontSize: 14, bgColor: K.brandGreen, textColor: .white, width: 80, height: 30, delayTime: 0.1)
        }
    }
   
   func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
     }
   
   @objc func downloadButtonPressed(sender: UIButton){
       sender.showAnimation {
           self.writeToPhotoAlbum(image: self.tartgetImage!)
           self.dismiss(animated: true, completion: nil)
       }
   }
    
    override func viewDidAppear(_ animated: Bool) {
        presentingController = presentingViewController
    }
    
    @objc func removePhoto(sender: UIButton) {
        sender.showAnimation {
            let alert = AlertController(title: "是否删除这张照片？", message: "", preferredStyle: .alert)
            let cancelAction = AlertAction(title: "取消", style: .normal) { AlertAction in
           
            }
            
            let deleteAction = AlertAction(title: "删除", style: .destructive) { AlertAction  in
                DBManager.shared.deleteImage(id: self.selectedImageID!)

                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "deletePhoto"), object: nil )
                
                self.shouldDismissSheet()
                self.dismiss(animated: false) {
                    self.presentingController?.dismiss(animated: true, completion: nil)
                }
      
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)

            alert.present()
        }

    }
    
    
    let downloadButton = Tools.setUpButtonWithSystemImage(systemName: "arrow.down.app", width: 37, height: 35, color: .black)

    let shareButton = Tools.setUpButtonWithSystemImage(systemName: "square.and.arrow.up", width: 35, height: 37, color: .black)
    
    let heartButton = Tools.setUpButtonWithSystemImage(systemName: "heart", width: 39, height: 35, color: .black)
    
    let deleteButton = Tools.setUpButtonWithSystemImage(systemName: "trash", width: 35, height: 35, color: .black)
    
    let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        return sv
    }()
    
    override func configureView() {
        super.configureView()
        self.contentViewCornerRadius = 10
        self.transitionDuration = 0.1
        Tools.setHeight(contentView, 80)

        deleteButton.addTarget(self, action: #selector(removePhoto(sender:)), for: .touchUpInside)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed(sender:)), for: .touchUpInside)
        
        buttonsStackView.addArrangedSubview(downloadButton)
        buttonsStackView.addArrangedSubview(shareButton)
        buttonsStackView.addArrangedSubview(heartButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        
        
        
        contentView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
    }
    
}
