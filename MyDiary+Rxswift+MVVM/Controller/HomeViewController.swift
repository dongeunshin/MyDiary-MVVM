//
//  HomeViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/08.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()

    // TODO: - 필요없는 부분 삭제
    // MARK: - Realm
//    let realm = try! Realm()
//    lazy var diary = self.realm.objects(Diary.self)
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
//        homeTableView.reloadData() // 왜 안됐을까??
        viewModel.reload()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let indexpath = self.homeTableView.indexPathForSelectedRow {
                print("passed")
                vc?.indexpath = indexpath
            }
        }
    }
    private func setupBinding(){
        viewModel.allDiary
            .bind(to: homeTableView.rx.items(cellIdentifier: "HomeTableViewCell", cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.dateLabel.text = item.date
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.content
                cell.img.image = UIImage(systemName: "heart")! // 사진 추가 기능 업데이트 중
            }
            .disposed(by: disposeBag)
        
        viewModel.reload()
        
        homeTableView.rx.itemDeleted
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexpath in
                self?.viewModel.delete(index: indexpath.row)
            })
            .disposed(by: disposeBag)
        
        homeTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showDetail", sender: self)
            }).disposed(by: disposeBag)
    }
}
