//
//  LevelsListTableViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 29/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class LevelsListVController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var levelsTableView: UITableView!
    @IBOutlet weak var addLevelTextField: UITextField!
    @IBOutlet weak var addLevelImageView: UIImageView!
    
    private var viewModel: LevelsListViewModel!
    private let cellIdentifier = "LevelCell"
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        setupTableViewBinding()
        setupAddingNewLevel()
    }
    
    private func setupViewModel() {
        var repo = LevelsRepository()
        self.viewModel = LevelsListViewModel(repo: repo)
    }
    
    private func setupTableView() {
        self.levelsTableView.delegate = nil
        self.levelsTableView.dataSource = nil
    }
    
    private func setupTableViewBinding() {
        viewModel.dataSource
            .bind(to: self.levelsTableView.rx.items(cellIdentifier: cellIdentifier, cellType: LevelTableViewCell.self)) {  row, element, cell in
                cell.levelNameLabel.text = element.Name
            }
            .disposed(by: disposeBag)
        
        levelsTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Select
        self.levelsTableView.rx
            .itemSelected
            .subscribe({ pair in
                print(pair)
            })
            .disposed(by: disposeBag)
    
        //
        self.levelsTableView.rx.itemDeleted.subscribe({ index in
            self.viewModel.deleteItem(at: index.element![1])
        })
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.levelsTableView.dataSource!.tableView!(self.levelsTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        
        
//         let updateButton = UITableViewRowAction(style: .default, title: "Update") { (action, indexPath) in
////            self.tableView.dataSource?.tableView!(self.tableView, commit: .editing, forRowAt: indexPath)
//            return
//         }
        
        return [deleteButton]
    }
    
    private func setupAddingNewLevel() {
        addLevelImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                // Add Level with name from addLevelTextField
                self.viewModel.addItem(item: DataLevel(Name: self.addLevelTextField.text!, Width: 10, Height: 10 ))
                
                // Close keyboard
                UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            .disposed(by: self.disposeBag)
    }

}


