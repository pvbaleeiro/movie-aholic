//
//  FavoriteViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 25/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit
import Foundation

class FavoriteViewController: ExploreFeedViewController {

    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //BUSCA OS FAVORITOS
        moviesTrending = SessionManager.sharedInstance.getFavoritesDetailMovie()
        tbvMovies.reloadData()
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Sets
    //-------------------------------------------------------------------------------------------------------------
    override func setLayout() {
        //Define layout table view
        view.addSubview(tbvMovies)
        
        tbvMovies.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tbvMovies.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tbvMovies.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tbvMovies.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    override func setData() {
        categories = ["My"]
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Acoes
    //-------------------------------------------------------------------------------------------------------------
    override func buscaDados(forceUpdate: Bool) {
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: UITableViewDataSource
    //-------------------------------------------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (moviesTrending != nil) {
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CategoryTableViewCell
        
        cell.title = categories[indexPath.section]
        cell.items = moviesTrending as! [MovieTrending]
        cell.indexPath = indexPath // needed for dismiss animation
        
        if let parent = parent as? CategoryTableViewCellDelegate {
            cell.delegate = parent
        }
        
        return cell
    }
}
