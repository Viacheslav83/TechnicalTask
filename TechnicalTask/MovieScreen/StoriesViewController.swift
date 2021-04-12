//
//  ViewController.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 10.04.2021.
//

import UIKit

enum TypeVideo: String {
    case topRated = "top_rated"
    case video = "popular"
    case favorites
}

class StoriesViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var movies: [Movie] = []
    var typeVideo: TypeVideo = .topRated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopView()
        
        collectionView.register(MovieCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(MovieTableViewCell.nib(),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        pageControl.addTarget(self, action: #selector(self.pageControlDidTapped(_:)), for: .valueChanged)
        getTopRatedMovies()
        
    }
    
    @objc func pageControlDidTapped(_ sender: UIPageControl) {
        let curentNumber = sender.currentPage
        collectionView.setContentOffset(CGPoint(x: curentNumber * Int(view.frame.width), y: 0), animated: true)
        
    }
    
    func setupTopView() {
        if typeVideo == .topRated {
            topView.isHidden = false
            topView.layer.cornerRadius = CGFloat(topView.frame.height / 2)
        } else {
            topView.isHidden = true
        }
    }
    
    private func getTopRatedMovies() {
        Service.setURL(partUrl: typeVideo.rawValue)
        Service.getToRated { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.processTopRatedMoviesResponse(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func processTopRatedMoviesResponse(_ response: MoviesResponse) {
        movies = response.results
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = response.results.count
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        print(response.results)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let searchViewController = searchStoryboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
            searchViewController.listVideos = movies.map { $0.title }
            present(searchViewController, animated: true)
        }
    }
    
    @IBAction func topRatedButtonTapped(_ sender: Any) {
        typeVideo = .topRated
        setupTopView()
        getTopRatedMovies()
        pageControl.numberOfPages = movies.count
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        typeVideo = .video
        setupTopView()
        pageControl.numberOfPages = movies.count
        getTopRatedMovies()
    }
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
        typeVideo = .favorites
        setupTopView()
        movies = []
        movies.append(Movie(title: "No Results", posterPath: "", releaseDate: "", voteAverage: 0))
        pageControl.numberOfPages = movies.count
        tableView.reloadData()
        collectionView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate
extension StoriesViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension StoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        if typeVideo == .favorites {
            tableCell.titleLabel.text = movies[indexPath.row].title
        } else {
            tableCell.configure(with: movies[indexPath.row])
        }
        return tableCell
    }
}

// MARK: - UICollectionViewDelegate
extension StoriesViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let item = view.frame.width
            let position = scrollView.contentOffset.x
            
            let number = Int(position / item)
            pageControl.currentPage = number
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        if typeVideo == .favorites {
            collectionCell.titleLabel.text = movies[indexPath.row].title
        } else {
            collectionCell.configure(with: movies[indexPath.row])
        }
        return collectionCell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 10,
                      height: collectionView.frame.height - 10)
    }
}
