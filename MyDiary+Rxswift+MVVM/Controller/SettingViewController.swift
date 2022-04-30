//
//  SettingViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/05/01.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordBttn: UIButton!
    
    @IBAction func passwordBttnAction(_ sender: Any) {
        guard let newPassword = passwordTextField.text else { return }
        do {
            try realm.write {
                password[0].password  = newPassword
            }
        } catch {
                print("Error")
        }
        passwordTextField.text = ""
        let alert = UIAlertController(title: "비밀번호가 변경되었습니다.", message: "새로운 비밀번호 : \(password[0].password)", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    let realm = try! Realm()
    lazy var password = self.realm.objects(Password.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
