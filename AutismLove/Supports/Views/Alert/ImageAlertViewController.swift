//
//  ImageAlertViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 15/02/21.
//

import UIKit

class ImageAlertViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: DefaultButton!
    
    var alertImage : UIImage?
    var alertDescription : String?
    
    var onOkAction : (()->(Void))?
    
    convenience init(alertImage : UIImage, alertDescription : String) {
        self.init()
        
        self.alertImage = alertImage
        self.alertDescription = alertDescription
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    convenience init(alertDescription : String) {
        self.init()
        
        self.alertImage = UIImage.init(named: "ic_alert")
        self.alertDescription = alertDescription
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate
        alertImageView.image = alertImage
        alertDescriptionLabel.text = alertDescription
        
        configureViews()
    }
    
    private func configureViews(){
        
        // Image
        alertImageView.contentMode = .scaleAspectFit
        alertImageView.tintColor = .PRIMARY_DARK
        
        // Background
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.4
        
        // button
        confirmButton.primaryBlueStyle()
        confirmButton.setTitle(Strings.Confirm, for: .normal)
        
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        onOkAction?()
    }
    
}
