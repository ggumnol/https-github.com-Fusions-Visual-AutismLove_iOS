//
//  ConfigurationBottomSheetViewController.swift
//  AutismLove
//
//  Created by BobbyPhtr on 07/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class ConfigurationBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var orderSettingsLabel: UILabel!
    @IBOutlet weak var closeButton: DefaultButton!
    
    @IBOutlet weak var groupByVolunteersLabel: UILabel!
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var groupByVolunteersPicker: UIPickerView!
    @IBOutlet weak var ordersPicker: UIPickerView!
    
    private let defaultFontSize : CGFloat = 18
    private let disposeBag = DisposeBag()
    
    var viewModel : TransactionViewModel!
    var onDismiss = PublishSubject<Bool>.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurePreferredContentSize()
    }
    
    private func configurePreferredContentSize(){
        let compressedSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: compressedSize.height)
    }
    
    private func configureViews(){
        orderSettingsLabel.text = Strings.Order_Settings
        orderSettingsLabel.font = UIFont.boldSystemFont(ofSize: 24)
        orderSettingsLabel.textColor = .PRIMARY_DARK
        
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.PRIMARY_DARK, for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        groupByVolunteersLabel.text = Strings.Group_Users_By_Volunteers
        groupByVolunteersLabel.font = UIFont.boldSystemFont(ofSize: defaultFontSize)
        groupByVolunteersLabel.textColor = .PRIMARY_DARK
        
        ordersLabel.text = Strings.Orders
        ordersLabel.font = UIFont.boldSystemFont(ofSize: defaultFontSize)
        ordersLabel.textColor = .PRIMARY_DARK
        
        ordersPicker.dataSource = self
        ordersPicker.delegate = self
        
        let idx = GroupingType.allCases.firstIndex(of: viewModel.usersOrderType.value)
        ordersPicker.selectRow(idx!, inComponent: 0, animated: false)
        
        groupByVolunteersPicker.dataSource = self
        groupByVolunteersPicker.delegate = self
        groupByVolunteersPicker.selectRow(viewModel.isGroupByUsers.value ? 0 : 1, inComponent: 0, animated: false)
        
//        viewModel.isGroupByUsers.value ? groupByVolunteersButton.setTitle(Strings.ON, for: .normal) :  groupByVolunteersButton.setTitle(Strings.OFF, for: .normal)
//        groupByVolunteersButton.setTitleColor(.PRIMARY_DARK, for: .normal)
//        groupByVolunteersButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: defaultFontSize)
//
//        ordersButton.setTitle(viewModel.usersOrderType.value.rawValue, for: .normal)
//        ordersButton.setTitleColor(.PRIMARY_DARK, for: .normal)
//        ordersButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: defaultFontSize)
//
//        ordersButton.inputView = ordersDatePicker
    }
    
    private func configureBindings(){
        closeButton.rx.tap.bind {
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onDismiss.onNext(true)
    }
}

extension ConfigurationBottomSheetViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ordersPicker {
            return GroupingType.allCases.count
        } else if pickerView == groupByVolunteersPicker {
            return 2
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel = UILabel()
        if let v = view as? UILabel{
            label = v
        }
        if pickerView == ordersPicker {
            label.text = GroupingType.allCases[row].rawValue
            label.font = UIFont.systemFont(ofSize: 16)
        } else if pickerView == groupByVolunteersPicker {
            // yang pertama adalah ON yang kedua adalah OFF
            if row == 0 {
                label.text =  Strings.ON
                label.font = UIFont.systemFont(ofSize: 16)
            } else {
                label.text =  Strings.OFF
                label.font = UIFont.systemFont(ofSize: 16)
            }
        }
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case ordersPicker:
            viewModel.usersOrderType.accept(GroupingType.allCases[row])
            break
        case groupByVolunteersPicker:
            row == 0 ? viewModel.isGroupByUsers.accept(true) : viewModel.isGroupByUsers.accept(false)
            break
        default:
            break
        }
    }
    
}
