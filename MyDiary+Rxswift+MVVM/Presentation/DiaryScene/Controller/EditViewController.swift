//
//  EditViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/04/28.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    lazy var password = self.realm.objects(Password.self)
    
    var indexpath : IndexPath?
    var t: String?
    var c: String?

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var luckBttn: UIButton!
    @IBOutlet weak var favBttn: UIButton!
    @IBAction func luckBttnAction(_ sender: Any) {
        if luckBttn.isSelected == true {
            self.luckBttn.isSelected = false
        }else {
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            if password.count == 0 {
                showAlert(state: .invaild)
            } else {
                showAlert(state: .check)
            }
        }
    }
    @IBAction func favBttnAction(_ sender: Any) {
        if favBttn.isSelected == true {
            favBttn.isSelected = false
        }else {
            favBttn.isSelected = true
        }
    }
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var contentLabel: UITextView!
    @IBAction func DoneBttnAction(_ sender: Any) {
        viewModel.editMemo(t: t, c: c, title: self.titleLabel.text!, condent: self.contentLabel.text!, isLocked: self.luckBttn.isSelected, isFav: self.favBttn.isSelected)
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI(){
        guard let t = t, let c = c else { return }
        let diary = viewModel.fetchData(title: t, condent: c)
        if let d = diary.first {
            dateLabel.text =  d.date
            titleLabel.text = d.title
            weatherLabel.text = d.weather
            contentLabel.text = d.content
            favBttn.isSelected = d.isFav
            luckBttn.isSelected = d.isLocked
        }
    }
    func showAlert(state : passwordCorrection) {
        let alert = UIAlertController(title: "잠깐!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        switch state {
        case .invaild:
            alert.message = "설정에서 비밀 번호를 설정해 주세요"
            alert.addAction(ok)
        case .check:
            alert.message = "비밀번호를 입력해 주세요"
            alert.addTextField { tf in
                tf.placeholder = "비밀번호 입력"
            }
            let submit = UIAlertAction(title: "Submit", style: .default) { _ in
                let passwordInput = alert.textFields?[0].text
                if self.password[0].password == passwordInput{
                    self.luckBttn.isSelected = true
                }else{
                    let faild = UIAlertController(title: "잠깐!", message: "비밀번호가 틀렸습니다", preferredStyle: .alert)
                    faild.addAction(ok)
                    self.present(faild, animated: true, completion: nil)
                }
            }
            alert.addAction(cancel)
            alert.addAction(submit)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
