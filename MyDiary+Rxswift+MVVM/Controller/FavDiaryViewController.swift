//
//  FavDiaryViewController.swift
//  MyDiary+Rxswift+MVVM
//
//  Created by dong eun shin on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class FavDiaryViewController: UIViewController {
    
    // MARK: - @IBOutlet properties
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reloadFavList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        tableviewItemSelected()
    }
    private func setupBinding(){
        viewModel.filteredDiaryList
            .bind(to: favTableView.rx.items(cellIdentifier: "FavTableViewCell", cellType: FavTableViewCell.self)) { index, item, cell in
                cell.dateLabel.text = item.date
                cell.titleLabel.text = item.title
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadFavList()
    }
    private func tableviewItemSelected(){
        favTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showDetail", sender: self)
            }).disposed(by: disposeBag)
    }
}
