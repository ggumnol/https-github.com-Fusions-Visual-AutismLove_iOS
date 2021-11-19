//
//  MessagingRoomViewController.swift
//  AutismLove
//
//  Created by Samuel Krisna on 04/05/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SVProgressHUD
import RxSwift
import RxCocoa
import Kingfisher

internal class MessagingRoomViewController: MessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    var documentId: String?
    
    var selfSender: Sender? {
        let senderId = (Globals.userData?.id)!
        return Sender(senderId: senderId, displayName: (Globals.userData?.name)!)
    }
    
    var messages = [MessageType]()
    var viewModel: MessagingViewModel!
    var room: RoomData?
    private let disposeBag = DisposeBag()
    var customFilePicker: CustomFilePicker!
    
    convenience init(viewModel: MessagingViewModel, documentId: String) {
        self.init()
        self.viewModel = viewModel
        self.documentId = documentId
    }
    
    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        
        let meNib = UINib(nibName: "MeCustomFileCollectionViewCell", bundle: nil)
        messagesCollectionView.register(meNib, forCellWithReuseIdentifier: "meCustomFileCollectionViewCell")
        
        let otherNib = UINib(nibName: "OtherCustomFileCollectionViewCell", bundle: nil)
        messagesCollectionView.register(otherNib, forCellWithReuseIdentifier: "otherCustomFileCollectionViewCell")
        
        messagesCollectionView.register(UINib(nibName: "TextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "textCell")
        
        super.viewDidLoad()
        
        configureMessageCollectionView()
        setupMessages()
        
        customFilePicker = CustomFilePicker(presentationController: self, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        messageInputBar.inputTextView.becomeFirstResponder()
        
        if let documentId = documentId {
            listenForMessages(id: documentId, shouldScrollToBottom: true)
        }
    }
    
    private func setupMessages() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        setupInputButton()
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if case .custom = message.kind {            
            if message.sender.senderId == Globals.userData?.id {
                let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: "meCustomFileCollectionViewCell", for: indexPath) as! MeCustomFileCollectionViewCell
                
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                
                cell.readL.text = "읽음"
                if let room = self.room, indexPath.section >= (messages.count - (room.total_unread ?? 0)) {
                    cell.readL.text = "안읽음"
                }
                
                return cell
            } else {
                let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: "otherCustomFileCollectionViewCell", for: indexPath) as! OtherCustomFileCollectionViewCell
                
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                
                return cell
            }
        }
        
        if case .text(let data) = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! TextCollectionViewCell
            cell.textL.text = data
            
            cell.setupOtherMessage()
            
            if message.sender.senderId == Globals.userData?.id {
                cell.setupMyMessage()
                if let room = self.room, indexPath.section >= (messages.count - (room.total_unread ?? 0)) {
                    cell.readL.text = "안읽음"
                }
            }
            return cell
        }
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func configureMessageCollectionView() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 8)
        
        // Set outgoing avatar to overlap with the message bubble
//        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 36))
//        layout?.setMessageOutgoingMessagePadding(UIEdgeInsets(top: outgoingAvatarOverlap, left: 24, bottom: outgoingAvatarOverlap, right: outgoingAvatarOverlap))
//
//        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
//        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
//        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
//        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
//        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 36, right: 36))
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        print("++++++++++++")
        print(messages[indexPath.section].kind)
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { _ in
            self.customFilePicker.present(from: self.view)
        }
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DispatchQueue.global(qos: .background).async { [self] in
            viewModel.getConversation(id: id) { [weak self] result in
                print("(DEBUG) MESSAGE")
                
                switch result {
                case .success(let messages):
                    guard !messages.isEmpty else {
                        print("messages are empty")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.messages = messages
                        self?.messagesCollectionView.reloadData()
                        
                        if shouldScrollToBottom {
                            self?.messagesCollectionView.scrollToLastItem()
                        }
                    }
                case .failure(let error):
                    print("failed to get messages: \(error)")
                }
            }
        }
    }
}

extension MessagingRoomViewController: FilePickerPrtcl {
    func didSelectDocument(file: Data?) {
        SVProgressHUD.show()
        viewModel.sendFile(file: file!).subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
        }.disposed(by: disposeBag)
    }
    
    func didSelect(image: UIImage?) {
        SVProgressHUD.show()
        viewModel.sendImage(image: image!).subscribe {
            SVProgressHUD.dismiss()
        } onError: { error in
            SVProgressHUD.dismiss()
        }.disposed(by: disposeBag)
    }
}

extension MessagingRoomViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            guard let message = messages[indexPath.section] as? Message else { return }
            
            switch message.kind {
            case .photo(let media):
                guard let imageUrl = media.url else { return }
                let vc = FullViewImageViewController()
                vc.setupData(imageUrl: imageUrl)
                vc.modalPresentationStyle = .popover
                
                self.present(vc, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

extension MessagingRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        viewModel.textObservable.accept(text)
        
        SVProgressHUD.show()
        viewModel.createMessage().subscribe(onDisposed:  {
            self.messageInputBar.inputTextView.text = nil
            SVProgressHUD.dismiss()
        }).disposed(by: disposeBag)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            // our message that we've sent
            return .link
        }
        return .secondarySystemBackground
    }
}

extension MessagingRoomViewController:  MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else { return }
            imageView.kf.setImage(with: imageUrl)
        default:
            break
        }
    }
}
