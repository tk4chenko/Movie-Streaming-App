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
        let items = ["Movies", "TVShows"]
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
        
        navigationItem.backButtonTitle = ""
        navigationItem.titleView?.tintColor = .red
        
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
        
        viewModel.fetchMovieWatchlist {
            self.tableView.reloadData()
        }
        
        viewModel.fetchTVShowsWatchlist {
            self.tableView.reloadData()
        }
    }
    
    @objc func segmentTapped() {
        segmentController.setupSegment()
        self.tableView.reloadData()
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
        case 0: return viewModel.arrayOfMoviesWatchlist.count
        case 1: return viewModel.arrayOfTVShowsWatchlist.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else { return UITableViewCell() }
        switch segmentController.selectedSegmentIndex {
        case 0: cell.configure(media: self.viewModel.arrayOfMoviesWatchlist[indexPath.row])
        case 1: cell.configure(media: self.viewModel.arrayOfTVShowsWatchlist[indexPath.row])
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
                self?.viewModel.remove(mediaType: "movie", mediaId: self?.viewModel.arrayOfMoviesWatchlist[indexPath.row].id ?? 0) {
                    self?.viewModel.arrayOfMoviesWatchlist.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            case 1:
                self?.viewModel.remove(mediaType: "tv", mediaId: self?.viewModel.arrayOfTVShowsWatchlist[indexPath.row].id ?? 0) {
                    self?.viewModel.arrayOfTVShowsWatchlist.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            default:
                return
            }
        }
        removeAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: DetailsViewController.identifier) as? DetailsViewController else { return }
        
        switch self.segmentController.selectedSegmentIndex {
        case 0:
            vc.configure(mediaType: "movie", media: viewModel.arrayOfMoviesWatchlist[indexPath.row])
        case 1:
            vc.configure(mediaType: "movie", media: viewModel.arrayOfTVShowsWatchlist[indexPath.row])
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
