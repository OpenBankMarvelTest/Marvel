//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class CharacterDetailViewController: ParentViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: CharactersViewModel?
    private var indexDetail: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func initVM(index: Int, charactersViewModel: CharactersViewModel?) {
        self.viewModel = charactersViewModel
        self.indexDetail = index
    }
}

//MARK: - private methods -
extension CharacterDetailViewController {

    private func configureUI() {
        imageCharacter.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if let imageView = viewModel?.getImageCharacter(index: indexDetail) {
            imageCharacter.image = imageView
            imageCharacter.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            viewModel?.downloadImagen(image: imageCharacter, activityIndicator: activityIndicator, index: indexDetail)
        }
        configureTableView()
    }
    
    private func configureTableView() {
         tableView.register(UINib(nibName: String(describing: SectionHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: SectionHeaderView.self))
        tableView.register(UINib(nibName: String(describing: HeaderCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderCell.self))
        tableView.register(UINib(nibName: String(describing: SectionView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: SectionView.self))
        tableView.register(UINib(nibName: String(describing: HeaderBodyCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HeaderBodyCell.self))
        tableView.register(UINib(nibName: String(describing: BodyCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BodyCell.self))
        tableView.register(UINib(nibName: String(describing: FooterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FooterCell.self))
        tableView.register(UINib(nibName: String(describing: UniqueCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UniqueCell.self))
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70
    }
    
    private func getSectionHeaderView(section: Int) -> UIView {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionHeaderView.self)) as! SectionHeaderView
        view.titleLabel.text = viewModel?.getNameDetail(index: indexDetail)
        return view
    }
    
    private func getSectionView(section: Int) -> UIView {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionView.self)) as! SectionView
        var title = ""
        switch section {
            case 1:
                title = "comics".localized
                break
            case 2:
                title = "stories".localized
                break
            case 3:
                title = "events".localized
                break
            case 4:
                title = "urls".localized
                break
            default:
                break
        }
        view.tag = section
        view.delegate = self
        view.titleLabel.text = title
        if viewModel?.getArrowDirection(section) ?? false {
            view.arrowImage.image = UIImage(named: "arrowTop")
        } else {
            view.arrowImage.image = UIImage(named: "arrowButton")
        }
        return view
    }
    
    private func getHeaderCell(indexPath: IndexPath) -> HeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
        cell.selectionStyle = .none
        if let detailDescription = viewModel?.getDescriptionDetail(index: indexDetail), !detailDescription.elementsEqual("") {
            cell.detailLabel.text = detailDescription
        } else {
            cell.detailLabel.text = ""
        }
        cell.titleLabel.text = "detail".localized
        cell.selectionStyle = .none
        return cell
    }
    
    private func getHeaderBodyCell(indexPath: IndexPath) -> HeaderBodyCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderBodyCell.self), for: indexPath) as! HeaderBodyCell
        cell.titleLabel.text = getTitleCell(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func getBodyCell(indexPath: IndexPath) -> BodyCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BodyCell.self), for: indexPath) as! BodyCell
        cell.titleLabel.text = getTitleCell(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func getFooterCell(indexPath: IndexPath) -> FooterCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FooterCell.self), for: indexPath) as! FooterCell
        cell.titleLabel.text = getTitleCell(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func getUniqueCell(indexPath: IndexPath) -> UniqueCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UniqueCell.self), for: indexPath) as! UniqueCell
        cell.titleLabel.text = getTitleCell(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func getTitleCell(indexPath: IndexPath) -> String? {
        switch indexPath.section {
            case 1:
                return viewModel?.getTitleOfComics(index: indexDetail, indexRow: indexPath.row)
            case 2:
                return viewModel?.getTitleOfStories(index: indexDetail, indexRow: indexPath.row)
            case 3:
                return viewModel?.getTitleOfEvents(index: indexDetail, indexRow: indexPath.row)
            case 4:
                return viewModel?.getTitleOfUrls(index: indexDetail, indexRow: indexPath.row)
            default:
                return ""
            }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return viewModel?.getNumberOfComics(index: indexDetail) ?? 0
            case 2:
                return viewModel?.getNumberOfStories(index: indexDetail) ?? 0
            case 3:
                return viewModel?.getNumberOfEvents(index: indexDetail) ?? 0
            case 4:
                return viewModel?.getNumberOfUrls(index: indexDetail) ?? 0
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                return getHeaderCell(indexPath: indexPath)
            case 1:
                if viewModel?.getNumberOfComics(index: indexDetail) ?? 0 == 1 {
                    return getUniqueCell(indexPath: indexPath)
                } else {
                    switch indexPath.row {
                        case (viewModel?.getNumberOfComics(index: indexDetail) ?? 0) - 1:
                            return getFooterCell(indexPath: indexPath)
                        case 0:
                            return getHeaderBodyCell(indexPath: indexPath)
                        default:
                            return getBodyCell(indexPath: indexPath)
                    }
                }
            case 2:
                if viewModel?.getNumberOfStories(index: indexDetail) ?? 0 == 1 {
                    return getUniqueCell(indexPath: indexPath)
                } else {
                    switch indexPath.row {
                        case (viewModel?.getNumberOfStories(index: indexDetail) ?? 0) - 1:
                            return getFooterCell(indexPath: indexPath)
                        case 0:
                            return getHeaderBodyCell(indexPath: indexPath)
                        default:
                            return getBodyCell(indexPath: indexPath)
                    }
                }
            case 3:
                if viewModel?.getNumberOfEvents(index: indexDetail) ?? 0 == 1 {
                    return getUniqueCell(indexPath: indexPath)
                } else {
                    switch indexPath.row {
                        case (viewModel?.getNumberOfEvents(index: indexDetail) ?? 0) - 1:
                            return getFooterCell(indexPath: indexPath)
                        case 0:
                            return getHeaderBodyCell(indexPath: indexPath)
                        default:
                            return getBodyCell(indexPath: indexPath)
                    }
                }
            case 4:
                if viewModel?.getNumberOfUrls(index: indexDetail) ?? 0 == 1 {
                    return getUniqueCell(indexPath: indexPath)
                } else {
                    switch indexPath.row {
                        case (viewModel?.getNumberOfUrls(index: indexDetail) ?? 0) - 1:
                            return getFooterCell(indexPath: indexPath)
                        case 0:
                            return getHeaderBodyCell(indexPath: indexPath)
                        default:
                            return getBodyCell(indexPath: indexPath)
                    }
                }
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 1, 2, 3, 4:
                return getSectionView(section: section)
            default:
                return getSectionHeaderView(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 4:
                openURL(url: viewModel?.getTitleOfUrls(index: indexDetail, indexRow: indexPath.row) ?? "")
                break
            default:
                break
        }
        
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CharacterDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //dismissPresentedView()
        return true
    }
}

// MARK: - ProductHeaderSectionTitleViewDelegate
extension CharacterDetailViewController: SectionViewDelegate {
    func arrowClicked(section: Int) {
        viewModel?.arrowClicked(section)
        tableView.reloadSections([section], with: .automatic)
    }
}
