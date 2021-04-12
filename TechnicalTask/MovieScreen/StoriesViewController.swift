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
    case favorites = ""
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

    @IBAction func topRatedButtonTapped(_ sender: Any) {
        typeVideo = .topRated
        setupTopView()
        getTopRatedMovies()
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        typeVideo = .video
        setupTopView()
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

extension StoriesViewController: UITableViewDelegate {
    
}

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

extension StoriesViewController: UICollectionViewDelegate {
    
}

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

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - 16,
                      height: collectionView.frame.height - 10)
    }
}
