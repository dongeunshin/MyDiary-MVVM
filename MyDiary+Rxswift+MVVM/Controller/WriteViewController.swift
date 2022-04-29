//
//  WriteViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/08.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class WriteViewController: UIViewController {
    
    // MARK: - @IBOutlet properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var favBttn: UIButton!
    @IBOutlet weak var lockBttn: UIButton!
    @IBAction func favBttnAction(_ sender: Any) {
        if favBttn.isSelected == true {
            favBttn.isSelected = false
        }else {
            favBttn.isSelected = true
        }
    }
    @IBAction func lockBttnAction(_ sender: Any) {
        if lockBttn.isSelected == true {
            lockBttn.isSelected = false
        }else {
            lockBttn.isSelected = true
        }
    }
    @IBAction func SaveBtn(_ sender: Any) {
        var tmpIsFav = false
        var tmpIsLocked = false
        if self.diaryTextView.text == "오늘의 일기를 적어바" || self.diaryTextView.text == "" || self.titleTextField.text == ""{
            let alert = UIAlertController(title: "알림", message: "제목과 내용을 적어야 저장 할 수 있어", preferredStyle: UIAlertController.Style.alert)
            let defaultAction =  UIAlertAction(title: "알겠어", style: UIAlertAction.Style.cancel)
            alert.addAction(defaultAction)
            self.present(alert, animated: false)
        }else{
            guard let date = dateLabel.text, let weather = weatherLabel.text, let title = titleTextField.text, let content = diaryTextView.text else { return }
            if favBttn.isSelected == true { tmpIsFav = true }
            if lockBttn.isSelected == true { tmpIsLocked = true }
            let newDiary = Diary(date: date, title: title, content: content, weather: weather, isFav: tmpIsFav, isLocked: tmpIsLocked) //, img:  NSData(data: UIImage(systemName: "pencil")!.pngData()!) as Data
            weatherViewModel.save(diary: newDiary)
            self.navigationController?.popViewController(animated: false)
        }
        let realm = try! Realm()
        lazy var diary = self.realm.objects(Diary.self)
        print(diary)
    }
    
    // MARK: -
    var realm = try! Realm()
    var disposeBag = DisposeBag()
    let weatherViewModel = WeatherViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDate()
        setupBinding()
    }
    
    private func setupDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let now = formatter.string(from: Date())
        dateLabel.text = now
    }
    private func setupBinding() {
        weatherViewModel.todayWeather
            .bind(to: weatherLabel.rx.text)
            .disposed(by: disposeBag)
        
        weatherViewModel.reload()
        
        diaryTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.diaryTextView.textColor == UIColor.systemGray {
                    self.diaryTextView.text = nil
                    self.diaryTextView.textColor = UIColor.black
                }})
            .disposed(by: disposeBag)
        
        diaryTextView.rx.didEndEditing
            .subscribe { _ in
                if self.diaryTextView.text.isEmpty {
                    self.diaryTextView.text = "오늘의 일기를 적어바"
                    self.diaryTextView.textColor = UIColor.systemGray
                }
            }
            .disposed(by: disposeBag)
    }
}
