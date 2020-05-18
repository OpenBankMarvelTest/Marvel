//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class CharactersListViewController: ParentViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageError: UIImageView!
    @IBOutlet weak var labelError: UILabel!

    private var viewModel: CharactersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initVM()
    }
}

//MARK: - private methods -
extension CharactersListViewController {
    
    private func initVM() {
        showHUD()
        viewModel = CharactersViewModel(serviceHandler: CharactersServiceHandler(), delegate: self)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: CharacterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CharacterCell.self))
        tableView.register(UINib(nibName: String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoadingCell.self))
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
    }
    
    private func isHiddenElementsView(_ isHidden: Bool) {
        tableView.isHidden = isHidden
        imageError.isHidden = !isHidden
        labelError.isHidden = !isHidden
    }
    
    private func getLoadingCell(indexPath: IndexPath) -> LoadingCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath) as! LoadingCell
        cell.loading.startAnimating()
        cell.selectionStyle = .none
        viewModel?.fetchDataListCharacters()
        return cell
    }
    
    private func getCharacterCell(indexPath: IndexPath) -> CharacterCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterCell.self), for: indexPath) as! CharacterCell
        cell.name.text = viewModel?.getNameOfCharacters(index: indexPath.row) ?? ""
        cell.selectionStyle = .none
        let lastIndex = (viewModel?.isPagination() ?? false) ? 2 : 1
        let numberOf = viewModel?.getNumberOfCharacters() ?? 0
        if indexPath.row ==  numberOf - lastIndex {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        cell.imageCharacter.isHidden = true
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        viewModel?.downloadImagen(image: cell.imageCharacter, activityIndicator: cell.activityIndicator, index: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfCharacters() ?? 0 + ((viewModel?.isPagination() ?? false) ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ((viewModel?.getNumberOfCharacters() ?? 0) - 1) && viewModel?.isPagination() ?? false {
            return getLoadingCell(indexPath: indexPath)
        } else {
            return getCharacterCell(indexPath: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHUD()
        viewModel?.fetchDataDetailCharacter(index: indexPath.row)
    }
}

// MARK: - CharactersViewModelProtocol
extension CharactersListViewController: CharactersViewModelProtocol {
    func reloadCellTableView(index: Int) {
        tableView.reloadRows(at: [IndexPath(item: index, section: 1)], with: UITableView.RowAnimation.automatic)
    }
    
    func reloadTableView() {
        tableView.reloadData()
        hideHUD()
        isHiddenElementsView(false)
    }
    
    func errorService(error: ErrorModel) {
        hideHUD()
        alertError(error: error)
        if viewModel?.getNumberOfCharacters() == 0 {
            isHiddenElementsView(true)
            labelError.text = error.message
        }
    }
    
    func detailCharacter(index: Int) {
        hideHUD()
        let characterDetailViewControlle = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as! CharacterDetailViewController
        characterDetailViewControlle.initVM(index: index, charactersViewModel: viewModel)
        self.navigationController?.pushViewController(characterDetailViewControlle, animated: true)
    }
}
