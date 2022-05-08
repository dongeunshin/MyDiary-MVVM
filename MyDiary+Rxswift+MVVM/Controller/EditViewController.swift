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
            if password.count == 0 {
                let alert = UIAlertController(title: "잠깐!", message: "설정에서 비밀번호를 설정해 주세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "잠깐!", message: "비밀 모드로 전환을 위해 비밀번호를 입력해 주세요", preferredStyle: .alert)
                alert.addTextField { tf in
                    tf.placeholder = "비밀번호 입력"
                }
                let submit = UIAlertAction(title: "Submit", style: .default) { (ok) in
                    let passwordInput = alert.textFields?[0].text
                    if self.password[0].password == passwordInput{
                        self.luckBttn.isSelected = true
                    }else{
                        let alert2 = UIAlertController(title: "비밀반호가 틀렸습니다.", message: "비밀번호는 1234", preferredStyle: .alert)
                        let retry = UIAlertAction(title: "OK", style: .cancel)
                        alert2.addAction(retry)
                        self.present(alert2, animated: true, completion: nil)
                    }
                }
                let cancel = UIAlertAction(title: "cancel", style: .cancel)
                alert.addAction(cancel)
                alert.addAction(submit)
                self.present(alert, animated: true, completion: nil)
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
        do {
            try realm.write {
                guard let t = t, let c = c else { return }
                let d = viewModel.fetchData(title: t, condent: c)
                let currDiary = d.first!
                currDiary.title = self.titleLabel.text ?? "tmptitle"
                currDiary.content = self.contentLabel.text ?? "tmptitle"
                currDiary.isLocked = self.luckBttn.isSelected
                currDiary.isFav = self.favBttn.isSelected
            }
        } catch {
                print("Error")
        }
        
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
