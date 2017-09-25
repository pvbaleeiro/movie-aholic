//
//  ExploreFeedViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit
import Foundation

class ExploreFeedViewController: BaseTableController {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    let cellID = "cellID"
    var categories = ["Trending"]
    var moviesTrending: NSMutableArray!
    
    lazy var tbvMovies: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(CategoryTableViewCell.self, forCellReuseIdentifier: self.cellID)
        view.rowHeight = 300
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.allowsSelection = false
        return view
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Ciclo de vida
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setData()
        setText()
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Sets
    //-------------------------------------------------------------------------------------------------------------
    func setLayout() {
        
        //Define layout table view
        view.addSubview(tbvMovies)
        
        tbvMovies.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tbvMovies.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tbvMovies.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tbvMovies.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setData() {
        //Buscar os dados
        APIMovie.getTrendingMovies() {
            (response) in
            
            switch response {
            case .onSuccess(let trendingMovies as NSMutableArray):
                
                //Obtem resposta e atribui à lista
                self.moviesTrending = trendingMovies
                self.tbvMovies.reloadData()
                break
                
            case .onError(let erro):
                print(erro)
                break
                
            case .onNoConnection():
                print("Sem conexão")
                break
                
            default: break
            }
        }
    }
    
    func setText() {
        
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: UITableViewDataSource
//-------------------------------------------------------------------------------------------------------------
extension ExploreFeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (moviesTrending != nil) {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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



