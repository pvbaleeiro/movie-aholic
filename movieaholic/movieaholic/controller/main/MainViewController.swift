//
//  ExploreViewController.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Propriedades
    //-------------------------------------------------------------------------------------------------------------
    var currentPageController: UIViewController?
    var isFirstAppear: Bool = true
    
    var minHeaderHeight: CGFloat {
        return headerView.minHeaderHeight
    }
    var midHeaderHeight: CGFloat {
        return headerView.midHeaderHeight
    }
    var maxHeaderHeight: CGFloat {
        return headerView.maxHeaderHeight
    }
    var headerViewHeightConstraint: NSLayoutConstraint?
    
    let imageExpandAnimationController = ImageExpandAnimationController()
    let imageShrinkAnimationController = ImageShrinkAnimationController()
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Views
    //-------------------------------------------------------------------------------------------------------------
    lazy var headerView: ExploreHeaderView = {
        let view = ExploreHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.pageTabDelegate = self
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var feedController: ExploreFeedViewController = {
        let controller = ExploreFeedViewController()
        controller.title = "MOVIES"
        return controller
    }()
    
    var favoriteController: FavoriteViewController = {
        let controller = FavoriteViewController()
        controller.title = "FAVORITE"
        return controller
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppear {
            headerViewHeightConstraint?.constant = maxHeaderHeight
            isFirstAppear = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentPageController?.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return currentPageController?.preferredStatusBarUpdateAnimation ?? .fade
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentPageController?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return currentPageController?.prefersStatusBarHidden ?? false
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Sets
    //-------------------------------------------------------------------------------------------------------------
    func setLayout() {
        
        //Define layout header view
        view.addSubview(headerView)
        
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: maxHeaderHeight)
        headerViewHeightConstraint?.isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //Define layout content view
        view.addSubview(contentView)
        
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setData() {
        //Define dados header view
        headerView.pageTabControllers = [feedController, favoriteController]
        
        //Define dados content view
        setContent(toViewControllerAtIndex: 0)        
    }
    
    func setText() {
        
    }
}

extension MainViewController: BaseTableControllerDelegate {
    func layoutViews() {
        view.layoutIfNeeded()
    }
    
    func updateStatusBar() {
        if let parent = tabBarController {
            parent.setNeedsStatusBarAppearanceUpdate()
        } else {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: Sets
//-------------------------------------------------------------------------------------------------------------
extension MainViewController: ExploreHeaderViewDelegate {
    
    func didSelect(viewController: UIViewController, completion: (() -> Void)?) {
        setContent(toViewController: viewController, completion: completion)
    }
    
    func setContent(toViewController viewController: UIViewController, completion: (() -> Void)?) {
        if currentPageController != viewController {
            
            let content = viewController.view!
            
            if currentPageController != nil {
                currentPageController!.removeFromParentViewController()
                currentPageController!.view.removeFromSuperview()
                currentPageController!.willMove(toParentViewController: nil)
            }
            
            currentPageController = viewController
            
            addChildViewController(viewController)
            contentView.addSubview(content)
            viewController.didMove(toParentViewController: self)
            
            content.translatesAutoresizingMaskIntoConstraints = false
            content.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            content.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
            content.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            
        }
        
        if let handler = completion {
            handler()
        }
    }
    
    func setContent(toViewControllerAtIndex index: Int) {
        if  index >= 0, index < headerView.pageTabControllers.count {
            let vc = headerView.pageTabControllers[index]
            
            setContent(toViewController: vc) {
                self.headerView.animatePageTabSelection(toIndex: index)
            }
        }
    }
    
    func didCollapseHeader(completion: (() -> Void)?) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            let oldHeight = self.headerView.frame.size.height
            self.headerViewHeightConstraint?.constant = self.midHeaderHeight
            self.headerView.updateHeader(newHeight: self.midHeaderHeight, offset: self.midHeaderHeight - oldHeight)
            self.view.layoutIfNeeded()
        })
    }
    
    func didExpandHeader(completion: (() -> Void)?) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            let oldHeight = self.headerView.frame.size.height
            self.headerViewHeightConstraint?.constant = self.maxHeaderHeight
            self.headerView.updateHeader(newHeight: self.maxHeaderHeight, offset: self.maxHeaderHeight - oldHeight)
            self.view.layoutIfNeeded()
        })
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: CategoryTableViewCellDelegate
//-------------------------------------------------------------------------------------------------------------
extension MainViewController: CategoryTableViewCellDelegate {
    
    func categoryTableCell(_ tableCell: CategoryTableViewCell, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Cria alert sheet para compartilhar ou ir para detalhes
        let alert = UIAlertController(title: "Movieaholic", message: "Selecione uma das opções abaixo", preferredStyle: .actionSheet)
        //Adiciona ações
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("Cancelado.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Compartilhar imagem", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("Compartilhar.")
            let cell = collectionView.cellForItem(at: indexPath) as! HomeItemCell
            let activityItem: [AnyObject] = [cell.imgPoster.image as AnyObject]
            SessionManager.sharedInstance.shareWithSocial(onController: self, activityItem: activityItem)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ver detalhes", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("Detalhes.")
            let cell = collectionView.cellForItem(at: indexPath) as! HomeItemCell
            let frame = cell.convert(cell.imgPoster.frame, to: self.view)
            self.imageExpandAnimationController.originFrame = frame
            
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let detailViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
            detailViewController.tableIndexPath = tableCell.indexPath
            detailViewController.cellIndexPath = indexPath
            detailViewController.movieImages = SessionManager.sharedInstance.getImageMovies(forId: (cell.movie?.movie?.ids?.tmdb)!)
            detailViewController.transitioningDelegate = self
            
            //Carregando os detalhes...
            let traktId : Int = (cell.movie?.movie?.ids?.trakt)!
            APIMovie.getDetailsMovies(traktId: traktId) {
                (response) in
                
                switch response {
                case .onSuccess(let movieDetails as MovieDetail):
                    
                    //Atribui ao objeto da próxima tela
                    detailViewController.movieDetail = movieDetails
                    self.present(detailViewController, animated: true, completion: nil)
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
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


//-------------------------------------------------------------------------------------------------------------
// MARK: UIViewControllerTransitioningDelegate
//-------------------------------------------------------------------------------------------------------------
extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return imageExpandAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let dismissed = dismissed as? DetailMovieViewController,
            let presentingVC = currentPageController as? BaseTableController else {
                return nil
        }
        
        if let presentingVC = presentingVC as? ExploreFeedViewController,
            let tableIndexPath = dismissed.tableIndexPath,
            let cellIndexPath = dismissed.cellIndexPath {
            
            let tableCell = presentingVC.tbvMovies.cellForRow(at: tableIndexPath) as! CategoryTableViewCell
            let collectionCell = tableCell.collectionView.cellForItem(at: cellIndexPath) as! HomeItemCell
            
            let frame = collectionCell.convert(collectionCell.imgPoster.frame, to: view)
            imageShrinkAnimationController.destinationFrame = frame
        }
        
        return imageShrinkAnimationController
    }
}
