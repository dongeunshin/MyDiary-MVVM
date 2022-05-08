//
//  PasswordViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/05/01.
//

import UIKit
import RealmSwift

class PasswordViewController: UIViewController {
    
    let realm = try! Realm()
    lazy var password = self.realm.objects(Password.self)

    // MARK: - @IBOutlet properties
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func passwordBttnAction(_ sender: Any) {

        let newPW = passwordTextField.text!
        if password.count == 0{
            do{
                try realm.write{ realm.add(Password(password: newPW)) }
            } catch {
                print("Error: \(error)")
            }
        }else {
            do {
                try realm.write {
                    password.first?.password = newPW
                }
            } catch {
                    print("Error")
            }
        }

        passwordTextField.text = ""
        let alert = UIAlertController(title: "비밀번호가 변경되었습니다.", message: "새로운 비밀번호 : \(password.first!.password)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in 
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
