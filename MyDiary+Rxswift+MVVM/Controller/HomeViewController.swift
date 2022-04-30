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
    
    @IBOutlet weak var searchBar: UISearchBar!
    let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()

    // TODO: - 필요없는 부분 삭제
    // MARK: - Realm
    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    lazy var password = self.realm.objects(Password.self)
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        do{
            try realm.write{ realm.add(Password(password: "1234")) }
        } catch {
            print("Error: \(error)")
        }
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
                cell.contentLabel.text = item.isLocked ? "비밀 메모입니다" : item.content
                cell.img.image = item.isLocked ? UIImage(systemName: "lock")! : UIImage(systemName: "lock.open")!
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
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
                vc.indexpath = indexPath
                print("selected")

                if self.diary[indexPath.row].isLocked {
                    let alert = UIAlertController(title: "비밀메모 입니다", message: "비밀번호를 입력해 주세요", preferredStyle: .alert)
                    alert.addTextField { tf in
                        tf.placeholder = "비밀번호 입력"
                    }
                    let submit = UIAlertAction(title: "Submit", style: .default) { (ok) in
                        let passwordInput = alert.textFields?[0].text
                        if self.password[0].password == passwordInput{
                            self.navigationController?.pushViewController(vc, animated: true)
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
                }else {
//                    self.children.first?.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
