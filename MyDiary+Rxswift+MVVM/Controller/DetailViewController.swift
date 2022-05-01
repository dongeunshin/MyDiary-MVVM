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
    let viewModel = HomeViewModel()
    var indexpath: IndexPath?
    
    var t: String?
    var c: String?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var lockBttn: UIButton!
    @IBOutlet weak var starBttn: UIButton!
    
    @IBOutlet weak var editBttn: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showEdit" {
            let vc = segue.destination as? EditViewController
            if let indexpath = indexpath {
                vc?.indexpath = indexpath
                vc?.t = self.diary[indexpath.row].title
                vc?.c = self.diary[indexpath.row].content
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
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
            starBttn.isSelected = d.isFav
            lockBttn.isSelected = d.isLocked
        }
        
//        guard let t = t, let c = c else { return }
//        let diary = viewModel.fetchData(title: t, condent: c)
//        if let d = diary.first {
//            dateLabel.text =  d.date
//            titleLabel.text = d.title
//            weatherLabel.text = d.weather
//            contentLabel.text = d.content
//            starBttn.isSelected = d.isFav
//            lockBttn.isSelected = d.isLocked
//        }
    }
}
