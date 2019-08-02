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

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
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
        
    }

    func setUpBindings() {
        // Search bar binding
        searchSC.searchBar
            .rx.text.orEmpty
            .bind(to: viewModel.keyword)
            .disposed(by: disposeBag)
        
        // Tableview binding
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        viewModel.videos
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row,track,cell) in
                cell.textLabel?.text = track.videoTitle
            }.disposed(by: disposeBag)
    }
}
