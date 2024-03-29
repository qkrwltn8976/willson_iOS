//
//  AskerLoginViewController.swift
//  Willson
//
//  Created by 박지수 on 29/06/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import KakaoOpenSDK

class AskerLoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var kakaotalkBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet var loginView: UIView!
    
    var model: UserSigninService?
    var signIn: SignIn?
    var statusCode: Int?
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconTF()
        emailTF.delegate = self
        pwTF.delegate = self
        
        // view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)

    }
    
    func viewWillApear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccessToken() //sns 로그인
    }
    
    // MARK: - IBAction
    
    // 일반 로그인
    @IBAction func tappedLoginButton(_ sender: Any) {
        guard let email = emailTF.text else {return}
        guard let password = pwTF.text else {return}
        
        if !emailTF.hasText {
            self.view.makeToast("다시 입력해주세요", duration: 3.0, position: .bottom)
            self.emailTF.text = ""
            self.pwTF.text = ""
            self.emailTF.resignFirstResponder()
        }
        if !pwTF.hasText {
            self.view.makeToast("다시 입력해주세요", duration: 3.0, position: .bottom)
            self.emailTF.text = ""
            self.pwTF.text = ""
            self.pwTF.resignFirstResponder()
        }
        
        UserSigninService.shared.login(email: email, password: password) {
            signIn, statusCode in
            
            switch statusCode {
            case 202:
                self.view.makeToast("다시 입력해주세요", duration: 3.0, position: .bottom)
                self.emailTF.text = ""
                self.pwTF.text = ""
                self.emailTF.resignFirstResponder()
                self.pwTF.resignFirstResponder()
            case 200:
                self.signIn = signIn
                self.statusCode = statusCode
                //print(signIn.message)
                UserDefaults.standard.set(signIn.data.token, forKey: "token")
                
                //화면 이동
                let storyboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AskerTabbar")
                self.present(viewController, animated: true)
            default :
                break;
            }
            
        }
    }
    
    // 페이스북 로그인
    @IBAction func facebookBtnAction(_ sender: Any) {
        var getEmail = ""
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((AccessToken.current) != nil){
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    let dict: NSDictionary = result as! NSDictionary
                                    if let token = AccessToken.current?.tokenString {
                                        print("tocken: \(token)")
                                        
                                        let userDefult = UserDefaults.standard
                                        userDefult.setValue(token, forKey: "access_tocken")
                                        userDefult.synchronize()
                                    }
                                    if let user : NSString = dict.object(forKey:"name") as! NSString? {
                                        print("user: \(user)")
                                    }
                                    if let id : NSString = dict.object(forKey:"id") as? NSString {
                                        print("id: \(id)")
                                    }
                                    if let email : NSString = (result! as AnyObject).value(forKey: "email") as? NSString {
                                        print("email: \(email)")
                                        getEmail = email as String
                                    }
                                    
                                    
                                    //회원정보가 서버에 존재하지 않을 경우 회원가입 창으로 이동(데이터로 이메일 정보 전송)
                                    //let viewController = UIStoryboard(name: "AskerSignUp", bundle: nil).instantiateViewController(withIdentifier: "snsSignUpNavi")
                                   
                                    let dvc = UIStoryboard(name: "AskerSignUp", bundle: nil).instantiateViewController(withIdentifier: "AskerSNSSignUpViewController") as! AskerSNSSignUpViewController
                                     let navi = UINavigationController(rootViewController: dvc)
                                    
                                    dvc.snsEmail = getEmail
                                    self.present(navi, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func kakaotalkBtnAction(_ sender: Any) {
        var getEmail = ""
        if KOSession.shared().isOpen() { KOSession.shared().close() }
        KOSession.shared().presentingViewController = self
        
        func profile(_ error: Error?, user: KOUserMe?) {
            guard let user = user,
                error == nil else { return }
            
            guard let token = user.id else { return }
            let name = user.nickname ?? ""
            
            if let gender = user.account?.gender {
                if gender == KOUserGender.male {
                    print("male")
                } else if gender == KOUserGender.female {
                    print("female")
                }
            }
            
            let email = user.account?.email ?? ""
            let profile = user.profileImageURL?.absoluteString ?? ""
            let thumbnail = user.thumbnailImageURL?.absoluteString ?? ""
            
            print(token)
            print(name)
            print(email)
            print(profile)
            print(thumbnail)
            getEmail = email
        }
        
        KOSession.shared().open(completionHandler: { (error) in
            if error != nil || !KOSession.shared().isOpen() { return }
            KOSessionTask.userMeTask(completion: { (error, user) in
                if let account = user?.account {
                    var updateScopes = [String]()
                    if account.emailNeedsAgreement {
                        updateScopes.append("account_email")
                    }
                    
                    if account.genderNeedsAgreement {
                        updateScopes.append("gender")
                    }
                    
                    if account.genderNeedsAgreement {
                        updateScopes.append("birthday")
                    }
                    KOSession.shared()?.updateScopes(updateScopes, completionHandler: { (error) in
                        guard error == nil else {
                            return
                        }
                        KOSessionTask.userMeTask(completion: { (error, user) in
                            profile(error, user: user)
                            
                            let dvc = UIStoryboard(name: "AskerSignUp", bundle: nil).instantiateViewController(withIdentifier: "AskerSNSSignUpViewController") as! AskerSNSSignUpViewController
                            
                            
                            dvc.snsEmail = getEmail
                            self.present(dvc, animated: true, completion: nil)
                        })
                    })
                } else {
                    profile(error, user: user)
                }
            })
        })
    }
    
    
    @IBAction func signupBtnAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "AskerSignUp", bundle: nil).instantiateViewController(withIdentifier: "AskerSignUpNC") as! UINavigationController
        self.present(dvc, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getAccessToken() {
        guard let token = AccessToken.current else { return }
        
        print("#### AccessToken ####")
        print(token)
        print("#### AccessToken ####")
    }
    
    
    func iconTF() {
        emailTF.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 21, y: 17, width: 13, height: 14))
        let image = UIImage(named: "loginImgEmail")
        imageView.image = image
        emailTF.leftView = imageView
        
        
        pwTF.leftViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 21, y: 17, width: 13, height: 14))
        let image2 = UIImage(named: "loginImgPassword")
        imageView2.image = image2
        pwTF.leftView = imageView2
    }
    
    func snsSignup() {
        let dvc = UIStoryboard(name: "AskerSignUp", bundle: nil).instantiateViewController(withIdentifier: "AskerSNSSignUpViewController") as! AskerSNSSignUpViewController
        
        //dvc.email.text = getEmail
        self.present(dvc, animated: true, completion: nil)
    }
    
}

extension AskerLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if emailTF.text == "email" {
            emailTF.text = nil
        }
        if pwTF.text == "password" {
            pwTF.text = nil
        }
    }
}
