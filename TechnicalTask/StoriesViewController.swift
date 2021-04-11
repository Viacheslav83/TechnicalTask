//
//  ViewController.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 10.04.2021.
//

import UIKit

class StoriesViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(MovieTableViewCell.nib(),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

    }

    @IBAction func topRatedButtonTapped(_ sender: Any) {
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
    }
    
}

extension StoriesViewController: UITableViewDelegate {
    
}

extension StoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
//        tableCell.backgroundColor = .blue
        return tableCell
    }
}

extension StoriesViewController: UICollectionViewDelegate {
    
}

extension StoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
//        collectionCell.backgroundColor = .black
        return collectionCell
    }
    
}
