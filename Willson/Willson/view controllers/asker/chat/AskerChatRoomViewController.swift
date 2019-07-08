//
//  AskerChatRoomViewController.swift
//  Willson
//
//  Created by 박지수 on 07/07/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//

import UIKit

class AskerChatRoomViewController: UIViewController {

    // MARK: - properties
    let chatTableViewCellIdentifier: String = "ChatTableViewCell"
    var isTextFieldActive = false
    
    var messageArray = ["속상하셨겠어요ㅠㅠㅠ", "지금은 그래도 나아지셨다하니 더 잘될 거에요!", "감사합니다..", "ㅎ"]
    var timeArray = ["PM 07:11", "PM 07:11", "PM 07:12", "PM 07:13"]
    var userArray = [0, 0, 1, 1]
    
    // MARK: - IBOutlet
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "리트리버" + " 님"
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.rowHeight = 40
        
        textField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        self.chatRoomTableView.register(UINib(nibName: ChatHeaderTVC.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ChatHeaderTVC.reuseIdentifier)
        
        //유동적 셀높이 조정
        // 이거 한줄이면 됨... 왜?
        //chatRoomTableView.estimatedRowHeight = 40
    }
    
    // MARK: - IBAction
    @IBAction func sendMessageAction(_ sender: Any) {
        messageArray.append(textField.text!)
        timeArray.append("PM 07:52")
        userArray.append(1)
        
        let indexPath = IndexPath(row: self.messageArray.count-1, section:0)
        self.chatRoomTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
        textField.text = "" //텍스트 필드 초기화
    }
    
    // MARK: - Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if isTextFieldActive {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    //self.view.frame.origin.y -= keyboardSize.height
                    self.keyboardView.frame.origin.y -= keyboardSize.height
                }
            }
            
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !isTextFieldActive {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                //if self.view.frame.origin.y != 0{
                //self.view.frame.origin.y += keyboardSize.height
                self.keyboardView.frame.origin.y += keyboardSize.height
                //}
            }
            
            
        }
    }

}

// MARK: - UITableViewDelegate
extension AskerChatRoomViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension AskerChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        if userArray[indexPath.item] == 0 {
            if(indexPath.item != 0) {
                if(indexPath.item - 1 == 0) {
                    cell.profileImg.isHidden = true
                }
            }
            
            cell.profileImg.image = UIImage(named: "chatImgHelperprofile")
            cell.ownText.isHidden = true
            cell.ownView.isHidden = true
            cell.ownTime.isHidden = true
            //상대방
            cell.oppoText.text = messageArray[indexPath.item]
            cell.oppoTime.text = timeArray[indexPath.item]
            
           chatRoomTableView.rowHeight = CGFloat(cell.oppoText.numberOfVisibleLines * 40) //레이블 높이 조정
        } else {
            cell.profileImg.isHidden = true
            cell.oppoText.isHidden = true
            cell.oppoView.isHidden = true
            cell.oppoTime.isHidden = true
            //자신
            cell.ownText.text = messageArray[indexPath.item]
            cell.ownTime.text = timeArray[indexPath.item]
            
            chatRoomTableView.rowHeight = CGFloat(cell.ownText.numberOfVisibleLines * 40) //레이블 높이 조정
        }
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView: ChatHeaderTVC = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderTVC.reuseIdentifier) as? ChatHeaderTVC else { return UIView() }
        if let titleLabel = headerView.notificationTitle {
            titleLabel.text = "상담 대기 안내"
        }
        if let contentLabel = headerView.notificationContent {
            contentLabel.text = "질문자(답변자) 10분 이내 미 접속 시 대화 자동 종료 및 재매칭됩니다."
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView: ChatHeaderTVC = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderTVC.reuseIdentifier) as? ChatHeaderTVC else { return }
        
        headerView.clipsToBounds = true
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate
extension AskerChatRoomViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextFieldActive = true
        //keyboardWillShow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldActive = false
    }
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

