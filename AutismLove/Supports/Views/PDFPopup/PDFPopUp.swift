//
//  PDFPopUp.swift
//  AutismLove
//
//  Created by BobbyPhtr on 08/05/21.
//

import Foundation
import UIKit
import PDFKit
import RxSwift
import RxCocoa

class PDFPopUp : UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var downloadPdf: DefaultButton!

    let onPDFDownloadTappedObservable = PublishSubject<Bool>.init()
    
    var file : URL?
    
    convenience init(fileUrl : URL) {
        self.init()
        self.file = fileUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews(){
        downloadPdf.setTitle(Strings.Download_PDF, for: .normal)
        downloadPdf.primaryBlueStyle()
        
        // Background
        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.4
        
        guard let pdf = file  else { return }
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: pdf)
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func downloadPDFTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // Do save pdf here!
        onPDFDownloadTappedObservable.onNext(true)
    }
    
}
