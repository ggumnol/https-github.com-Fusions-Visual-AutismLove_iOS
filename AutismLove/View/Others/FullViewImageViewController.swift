//
//  FullViewImageViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 11/08/21.
//

import UIKit
import Kingfisher

class FullViewImageViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fullViewImage: UIImageView!
    
    var img : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        self.fullViewImage.image = img
    }
    
    func setupData(imageUrl: URL) {
        print("Image url: \(imageUrl)")
        view.backgroundColor = .black
        self.fullViewImage.kf.setImage(with: imageUrl)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let image = fullViewImage.image else { return }

            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
