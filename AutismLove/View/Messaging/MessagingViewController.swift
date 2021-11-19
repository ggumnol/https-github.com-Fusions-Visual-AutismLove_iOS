//
//  MessagingViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 25/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class MessagingViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MessagingViewModel!
    private let disposeBag = DisposeBag()

    convenience init(viewModel: MessagingViewModel) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationController()
        navigationTitleLogoImage()
        
        setupData()
    }
    
    func setupData() {
        viewModel.getAllMessage()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let customCell = UINib(nibName: "MessagingTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "messagingTableViewCell")
    }
    
    func openMessagingRoom(with indexPath: Int) {
        let room = viewModel.rooms[indexPath]
        let vc = MessagingRoomViewController(viewModel: viewModel, documentId: room.roomId!)
        viewModel.recipientIdObservable.accept(room.otherUser?.id)
        vc.title = room.otherUser?.name
        vc.room = room
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessagingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagingTableViewCell") as! MessagingTableViewCell
        
        let room = viewModel.rooms[indexPath.row]
        cell.nameLabel.text = room.otherUser?.name
        
        if room.messages?.last?.type == "image" {
            cell.messageLabel.text = Strings.Photo
        } else if room.messages?.last?.type == "file" {
            cell.messageLabel.text = "File"
        } else {
            cell.messageLabel.text = room.messages?.last?.text
        }
        
        if room.total_unread! > 0 {
            cell.unreadLabel.text = String(room.total_unread!)
        } else {
            cell.unreadLabel.isHidden = true
            cell.unreadBackground.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openMessagingRoom(with: indexPath.row)
    }
}

extension MessagingViewController: MessagingViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}
