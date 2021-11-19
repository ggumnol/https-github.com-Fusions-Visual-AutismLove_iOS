//
//  DateRangeBottomSheetController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 14/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class DateRangeBottomSheetController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: DefaultButton!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    private let defaultFontSize : CGFloat = 18
    private let disposeBag = DisposeBag()
    
    var viewModel : TransactionViewModel!
    var onDismiss = PublishSubject<(startDate : Date, endDate: Date)>.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurePreferredContentSize()
    }
    
    private func configureViews(){
        titleLabel.text = "Time Range"
        
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.PRIMARY_DARK, for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
    }
    
    private func configureBindings(){
        
        startDatePicker.addTarget(self, action: #selector(onDatePickerChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(onDatePickerChanged), for: .valueChanged)
        
        closeButton.rx.tap.bind { [unowned self] in
            self.onDismiss.onNext((startDatePicker.date, endDatePicker.date))
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    @objc private func onDatePickerChanged(){
    }
    
    private func configurePreferredContentSize(){
        let compressedSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: compressedSize.height)
    }
}
