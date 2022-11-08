//
//  WhatchlistViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 07.11.2022.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    var viewModel = ViewModelWatchlistVC()
    
    var watchlist = [Media]()
    
    var arrayOfNumbers = ["1", "2", "3", "4"]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView() // hide extra separator
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Watchlist"
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWatchlist(accountId: 14577701, sessionId: sessionId) { movies in
            self.watchlist = movies
            self.tableView.reloadData()
        }
    }
    
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        viewModel.arrayOfMoviesWatchlist.count
        watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else { return UITableViewCell() }
//        cell.configure(media: viewModel.arrayOfMoviesWatchlist[indexPath.row])
        cell.configure(media: watchlist[indexPath.row])
        //        let cell = UITableViewCell()
        //        cell.textLabel?.text = arrayOfNumbers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
}
