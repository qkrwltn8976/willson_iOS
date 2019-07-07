//
//  HelperChatRoomViewController.swift
//  Willson
//
//  Created by 박지수 on 06/07/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//

import UIKit

class HelperChatRoomViewController: UIViewController {

    let chatTableViewCellIdentifier: String = "ChatTableViewCell"
    let chatHeaderTableViewCellIdentifier: String = "ChatHeaderTVC"
    var isKeyboardAppear = false
    
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "리트리버" + " 님"
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.rowHeight = 40
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

      
        
        /*self.chatRoomTableView.register(UINib(nibName: ChatHeaderTVC.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ChatHeaderTVC.reuseIdentifier)*/
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    //self.view.frame.origin.y -= keyboardSize.height
                    self.keyboardView.frame.origin.y -= keyboardSize.height
                }
            }
            isKeyboardAppear = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    //self.view.frame.origin.y += keyboardSize.height
                    self.keyboardView.frame.origin.y += keyboardSize.height
                }
            }
            isKeyboardAppear = false
        }
    }
    /*
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
            keyboardView.bottomConstraint.constant = keyboardFrame.size.height + 20
    }*/
}

extension HelperChatRoomViewController: UITableViewDelegate {
    
}

extension HelperChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.profileImg.image = UIImage(named: "helperChatImgProfileWoman")
            cell.ownText.text = ""
            cell.oppoText.text = "안녕하세유-"
            cell.ownText.isHidden = true
            cell.ownView.isHidden = true
            cell.ownTime.isHidden = true
            
        
        case 1:
            cell.profileImg.isHidden = true
            cell.ownText.text = ""
            cell.oppoText.text = "리트리버님???"
            cell.ownText.isHidden = true
            cell.ownView.isHidden = true
            cell.ownTime.isHidden = true
        case 2:
            cell.profileImg.isHidden = true
            cell.ownText.text = "넹"
            cell.oppoText.text = ""
            cell.oppoText.isHidden = true
            cell.oppoView.isHidden = true
            cell.oppoTime.isHidden = true
        default:
            return cell
        }
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderTVC.reuseIdentifier) as! ChatHeaderTVC
        
        headerView.notificationTitle.text = "상담 대기 안내"
        headerView.notificationContent.text = "질문자(답변자) 10분 이내 미 접속 시 대화 자동 종료 및 재매칭됩니다."
    
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 138
    }*/
    
   
}
