//
//  EditViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/04/28.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    
    var indexpath : IndexPath?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var luckBttn: UIButton!
    @IBOutlet weak var favBttn: UIButton!

    @IBAction func luckBttnAction(_ sender: Any) {
        if luckBttn.isSelected == true {
            luckBttn.isSelected = false
        }else {
            luckBttn.isSelected = true
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
                guard let i = self.indexpath?.row else {return}
                let currDiary = diary[i]
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
        
        if let index = self.indexpath?.row {
            let d = diary[index]
            dateLabel.text =  d.date
            titleLabel.text = d.title
            weatherLabel.text = d.weather
            contentLabel.text = d.content
            luckBttn.isSelected = d.isLocked
            favBttn.isSelected = d.isFav
        }

    }
    
}
