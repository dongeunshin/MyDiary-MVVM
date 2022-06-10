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
    
    // MARK: - Controller
    let searchController = UISearchController(searchResultsController: nil)
    lazy var vc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController
    
    // MARK: - Realm
    let realm = try! Realm()
    lazy var diary = self.realm.objects(Diary.self)
    lazy var password = self.realm.objects(Password.self)
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setSearchController()
    }
    
    private func setSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "어떤 메모를 찾으시나요?"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        searchController.searchBar.showsCancelButton = false
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    private func setupBinding(){
        viewModel.allDiary
            .bind(to: homeTableView.rx.items(cellIdentifier: "HomeTableViewCell", cellType: HomeTableViewCell.self)) { index, item, cell in
                cell.dateLabel.text = item.date
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.isLocked ? "비밀 메모입니다" : item.content
                cell.img.image = item.isLocked ? UIImage(systemName: "lock")! : UIImage(systemName: "lock.open")!

                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowRadius = 10
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.layer.masksToBounds = true
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
                guard let vc = self.vc else { return }
                vc.indexpath = indexPath
                vc.t = self.diary[indexPath.row].title
                vc.c = self.diary[indexPath.row].content

                if self.diary[indexPath.row].isLocked {
                    self.showAlert(state: .check)
                }else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    func showAlert(state : passwordCorrection) {
        let alert = UIAlertController(title: "잠깐!", message: "비밀메모 입니다.", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "비밀번호 입력"
        }
        let ok = UIAlertAction(title: "OK", style: .cancel)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        switch state {
        case .invaild:
            break
        case .check:
            let submit = UIAlertAction(title: "Submit", style: .default) { _ in
                let passwordInput = alert.textFields?[0].text
                if self.password[0].password == passwordInput{
                    self.navigationController?.pushViewController(self.vc!, animated: true)
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

extension HomeViewController: UISearchResultsUpdating{
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false

    }
    func updateSearchResults(for searchController: UISearchController) {
        if ((searchController.searchBar.text?.isEmpty) == true){
            viewModel.reload()
        } else if let searchText = searchController.searchBar.text {
            viewModel.searchMemo(queryValue: searchText)
        }
    }
}

