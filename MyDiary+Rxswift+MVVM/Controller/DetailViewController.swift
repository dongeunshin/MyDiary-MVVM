//
//  DetailViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/03/13.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    
    var indexpath: IndexPath?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starBttn: UIButton!
    
    override func viewDidLoad() {
        setData()
    }
    
    private func setData(){
        if let index = self.indexpath?.row {
            let d = diary[index]
            dateLabel.text =  d.date
            titleLabel.text = d.title
            weatherLabel.text = d.weather
            contentLabel.text = d.content
        }
    }
}
