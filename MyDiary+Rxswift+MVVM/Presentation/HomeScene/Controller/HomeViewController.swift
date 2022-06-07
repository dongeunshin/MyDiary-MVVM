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

    let searchController = UISearchController(searchResultsController: nil)
    
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
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
                vc.indexpath = indexPath
                vc.t = self.diary[indexPath.row].title
                vc.c = self.diary[indexPath.row].content

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
                            let alert2 = UIAlertController(title: "비밀반호가 틀렸습니다.", message: "", preferredStyle: .alert)
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
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
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
