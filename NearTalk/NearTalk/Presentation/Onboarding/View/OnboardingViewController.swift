//
//  OnboardingViewController.swift
//  NearTalk
//
//  Created by Preston Kim on 2022/11/14.
//

import UIKit

final class OnboardingViewController: UserProfileInputViewController {
    // MARK: - Properties
    private let viewModel: any OnboardingViewModel
    
    // MARK: - Lifecycles
    init(viewModel: any OnboardingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.setButtonTitle(buttonTitle: "프로필 등록")
    }
    
    // MARK: - Helpers
    override func configureNavigationBar() {
        super.configureNavigationBar()

        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "프로필 등록"
    }
    
    override func bindNickNameField() {
        super.bindNickNameField()
        
        super.bindDisposable(
            self.rootView.nickNameText
                .bind(onNext: { [weak self] text in
                self?.viewModel.editNickName(text)
                }),
            
            self.viewModel.nickNameValiditionMessage
                .drive(self.rootView.nickNameValidityMessage),
            
            self.viewModel.nickNameValidity
                .map { isValid in
                    isValid ? UIColor.green : UIColor.red
                }
                .drive(self.rootView.nickNameValidityColor)
        )
    }
    
    override func bindMessageField() {
        super.bindMessageField()
        
        super.bindDisposable(
            self.rootView.messageText
                .bind(onNext: { [weak self] text in
                    self?.viewModel.editStatusMessage(text)
                }),
            
            self.viewModel.messageValiditionMessage
                .drive(self.rootView.messageValidityMessage),
            
            self.viewModel.messageValidity
                .map { isValid in
                    isValid ? UIColor.green : UIColor.red
                }
                .drive(self.rootView.messageValidityColor)
        )
    }
    
    override func bindProfileTap() {
        super.bindDisposable(
            self.rootView.tapProfileEvent
                .bind(onNext: { [weak self] _ in
                    self?.showPHPickerViewController()
                }),
            
            self.viewModel.image
                .compactMap { $0 }
                .map { UIImage(data: $0) }
                .drive(self.rootView.profileImage)
        )
    }
    
    override func imagePicked(_ image: UIImage?) {
        if let image: UIImage = image,
           let imageBinary: Data = self.resizeImageByUIGraphics(image: image) {
            self.viewModel.editImage(imageBinary)
        }
    }
    
    override func bindRegisterButton() {
        super.bindDisposable(
            self.viewModel.registerEnable
                .drive(self.rootView.registerEnable),

            self.rootView.registerBtnClickEvent
                .bind(onNext: { [weak self] _ in
                    self?.viewModel.register()
                }),
            
            self.viewModel.isUploading
                .drive(self.rootView.loadingIndicator),
            
            self.viewModel.isUploading
                .drive { self.rootView.isUserInteractionEnabled = !$0 }
        )
    }
}
