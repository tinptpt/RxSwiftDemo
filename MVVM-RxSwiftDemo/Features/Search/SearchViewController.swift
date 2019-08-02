//
//  SearchViewController.swift
//  MVVM-RxSwiftDemo
//
//  Created by Tin Phan Thanh on 7/31/19.
//  Copyright © 2019 Tin Phan Thanh. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController, LoadingAble {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    let searchSC = UISearchController(searchResultsController: nil)

    private let disposeBag = DisposeBag()
    private lazy var viewModel = SearchVideoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpBindings()
    }
    
    func setUpSearchBar() {
        navigationItem.searchController = searchSC
        definesPresentationContext = true
        searchSC.dimsBackgroundDuringPresentation = false
        searchSC.searchBar.showsCancelButton = true
        searchSC.isActive = true
    }

    func setUpBindings() {
        // Search bar binding
        searchSC.searchBar.rx
            .text.orEmpty
            .bind(to: viewModel.keyword).disposed(by: disposeBag)
        
        // Tableview binding
        tableView.register(VideoTableViewCell.nib, forCellReuseIdentifier: VideoTableViewCell.identifer)
        
        viewModel.videos
            .do(onError: { error in
                print(error.localizedDescription)
            })
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.items(cellIdentifier: VideoTableViewCell.identifer, cellType: VideoTableViewCell.self)) {
                // Shortten the code, there is 3 arguments in the closure (index, video, cell) stands for ($0, $1, $2)
                $2.config($1)
            }
            .disposed(by: disposeBag)


    }
}
