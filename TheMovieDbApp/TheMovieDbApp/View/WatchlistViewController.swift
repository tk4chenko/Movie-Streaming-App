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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
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
        viewModel.getWatchlist(accountId: accountId, sessionId: sessionId) { movies in
            self.watchlist = movies
            self.tableView.reloadData()
        }
    }
    
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else { return UITableViewCell() }
        cell.configure(media: watchlist[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .normal, title: "Remove") { [weak self]_, _, completion in
            self?.viewModel.removeFromWatchlist(accountID: accountId, mediaType: "movie", mediaId: self?.watchlist[indexPath.row].id ?? 0, sessionId: sessionId) { result, mediaId in
                self?.watchlist.remove(at: indexPath.row)
                print(result)
                print(mediaId)
                tableView.reloadData()
            }
            
        }
        
        removeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
}
