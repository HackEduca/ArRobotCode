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
    @IBOutlet weak var backImageView: UIImageView!
    
    // Will be a reference received from parent controller
    private var levelsRepository: LevelsRepository?
    
    private var viewModel: LevelsListViewModel!
    private let cellIdentifier = "LevelCell"
    private let disposeBag = DisposeBag()
    
    // Observer for the selected level
    public let selectedLevel = PublishSubject<DataLevel>()
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
        setupGoBack()
    }
    
    private func setupGoBack() {
        self.backImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe({ev in
            print("Go back clicked")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            // Instantiate the VC
            guard let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
                return
            }
            
            // Show
            self.present(mainViewController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
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
                var lvl = self.levelsRepository!.get(at: pair.element![1])
                self.selectedLevel.onNext( lvl )
            })
            .disposed(by: disposeBag)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.levelsTableView.dataSource!.tableView!(self.levelsTableView, commit: .delete, forRowAt: indexPath)
            return
        }
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
                data.Width = 5
                data.Height = 5
                data.ByUserID = UserRepository.shared.getUser()!.uid
                for _ in 0..<25 {
                    data.Tiles.append(DataTile())
                }
                self.viewModel.addItem(item: data)
            
                // Close keyboard
                UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            .disposed(by: self.disposeBag)
    }

}


