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
    
    // Will be a reference received from parent controller
    private var levelsRepository: LevelsRepository?
    
    private var viewModel: LevelsListViewModel!
    private let cellIdentifier = "LevelCell"
    private let disposeBag = DisposeBag()
    
    // Observer for the selected level
    public let selectedLevel: Variable<DataLevel> = Variable(DataLevel())
    public var selectedLevelObservable: Observable<DataLevel> {
            return selectedLevel.asObservable()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    func initialize() {
        //do your stuff here
        var levelBuilderVC = splitViewController?.viewControllers.last as? LevelBuilderViewController
        levelBuilderVC?.levelsListVController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setupRepository(repository: LevelsRepository) {
        self.levelsRepository = repository
        setupViewModel()
        setupTableView()
        setupTableViewBinding()
        setupTableViewItemSelected()
        setupAddingNewLevel()
    }
    
    private func setupViewModel() {
        self.viewModel = LevelsListViewModel(repo: self.levelsRepository!)
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
        
        //
        self.levelsTableView.rx.itemDeleted.subscribe({ index in
            self.viewModel.deleteItem(at: index.element![1])
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTableViewItemSelected() {
        // Select
        self.levelsTableView.rx
            .itemSelected
            .subscribe({ pair in
                self.selectedLevel.value = self.levelsRepository!.get(at: pair.element![1])
                print("Selected: ", pair.element![1], self.selectedLevel.value)
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
                let data = DataLevel()
                data.Name = self.addLevelTextField.text!
                data.Width = 10
                data.Height = 10
                for _ in 0..<100 {
                    data.Tiles.append(DataTile())
                }
                self.viewModel.addItem(item: data)
            
                // Close keyboard
                UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            .disposed(by: self.disposeBag)
    }

}


