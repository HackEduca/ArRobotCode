//
//  LevelsListViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 29/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LevelsListTableViewController: UITableViewController {
    @IBOutlet var levelsTableView: UITableView!
    
    private var viewModel: LevelsListViewModel!
    private let cellIdentifier = "LevelCell"
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        setupTableViewBinding()
    }
    
    private func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    private func setupViewModel() {
        self.viewModel = LevelsListViewModel()
        self.viewModel.addItem(item: "item1")
        self.viewModel.addItem(item: "item2")
        self.viewModel.addItem(item: "item3")
    }
    
    private func setupTableViewBinding() {
        viewModel.dataSource
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) {  row, element, cell in
                cell.textLabel?.text = "\(element) \(row)"
            }
            .disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
