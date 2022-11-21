//
//  WhatchlistViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 07.11.2022.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    private let viewModel = ViewModelWatchlistVC()
    
    private var watchlistOfMovies = [Media]()
    private var watchlistOfTVShows = [Media]()
    
    private let segmentController: UISegmentedControl = {
        let items = ["Movies", "TShows"]
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Watchlist"
        
        segmentController.setupSegment()
        
        segmentController.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMovieWatchlist(accountId: accountId, sessionId: sessionId) { movies in
            self.watchlistOfMovies = movies.reversed()
            self.tableView.reloadData()
        }
        
        viewModel.getTVShowsWatchlist(accountId: accountId, sessionId: sessionId) { tvShows in
            self.watchlistOfTVShows = tvShows.reversed()
            self.tableView.reloadData()
        }
        
    }
    
    @objc func segmentTapped() {
        segmentController.setupSegment()
        self.tableView.reloadData()
        //        print("RELOAD!!!")
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(segmentController)
        
        NSLayoutConstraint.activate([
            segmentController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            segmentController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0: return watchlistOfMovies.count
        case 1: return watchlistOfTVShows.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else { return UITableViewCell() }
        switch segmentController.selectedSegmentIndex {
        case 0: cell.configure(media: self.watchlistOfMovies[indexPath.row])
        case 1: cell.configure(media: self.watchlistOfTVShows[indexPath.row])
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.width * 0.3 + 16
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .normal, title: "Remove") { [weak self]_, _, completion in
            
            switch self?.segmentController.selectedSegmentIndex {
            case 0:
                self?.viewModel.removeFromWatchlist(accountID: accountId, mediaType: "movie", mediaId: self?.watchlistOfMovies[indexPath.row].id ?? 0, sessionId: sessionId) { result , mediatId in
                    self?.watchlistOfMovies.remove(at: indexPath.row)
                    tableView.reloadData()
                    print(result)
                    print(mediatId)
                }
            case 1:
                self?.viewModel.removeFromWatchlist(accountID: accountId, mediaType: "tv", mediaId: self?.watchlistOfTVShows[indexPath.row].id ?? 0, sessionId: sessionId) { result, mediaId in
                    self?.watchlistOfTVShows.remove(at: indexPath.row)
                    tableView.reloadData()
                    print(result)
                    print(mediaId)
                }
            default:
                return
            }
            
        }
        removeAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
}
