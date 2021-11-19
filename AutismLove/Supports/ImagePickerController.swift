//
//  ImagePickerController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 04/05/21.
//

import Foundation
import UIKit

protocol ImagePickerProtocol {
    func selectedImage(img: UIImage)
}

class ImagePickerController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var imagePickerProtocol: ImagePickerProtocol?
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImagePicker()
    }
    
    private func setupImagePicker() {
        vc.delegate = self
        vc.allowsEditing = true
    }
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Proof Image",
                                            message: "Select proof image",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [self] _ in
            presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [self] _ in
            presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        vc.sourceType = .camera
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        vc.sourceType = .photoLibrary
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        print(selectedImage)
        ImagePickerController.imagePickerProtocol?.selectedImage(img: selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
