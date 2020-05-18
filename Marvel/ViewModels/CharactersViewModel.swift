//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation
import UIKit

protocol CharactersViewModelProtocol: AnyObject {
    func reloadTableView()
    func reloadCellTableView(index: Int)
    func errorService(error: ErrorModel)
    func detailCharacter(index: Int)
}

final class CharactersViewModel {

    private weak var delegate: CharactersViewModelProtocol?
    private let serviceHandler: CharactersServiceHandler
    private var characters: CharactersModel?
    private let elementsPagination = 20
    private var arrowSection = [1: false, 2: false, 3: false, 4: false]
    
    init(serviceHandler: CharactersServiceHandler, delegate: CharactersViewModelProtocol) {
        self.serviceHandler = serviceHandler
        self.delegate = delegate
        if let data = UserPreferences.shared.load(forKey: UserPreferences.Key.charactersMarvel) {
            self.characters = CharactersModel.getModelFrom(data)
            self.delegate?.reloadTableView()
        } else {
            fetchDataListCharacters()
        }
    }
    
    func fetchDataListCharacters() {
        serviceHandler.getCharacters(offset: (characters?.data.offset != nil ? String(characters?.data.offset ?? 0) : nil), limit: (characters?.data.limit != nil ? String(characters?.data.limit ?? 0) : nil)) { [weak self] (response) in
            guard let weakself = self else { return }
            switch response {
                case .success(let characters):
                    if let characters = characters {
                        if weakself.characters == nil {
                            weakself.characters = characters
                        } else {
                            weakself.characters?.data.results.append(contentsOf: characters.data.results)
                            weakself.characters?.data.total = characters.data.total
                            weakself.characters?.data.count = characters.data.count
                        }
                        weakself.characters?.data.offset = characters.data.offset + weakself.elementsPagination
                        weakself.characters?.data.limit = characters.data.limit + weakself.elementsPagination
                    }
                    weakself.setPreferences()
                    weakself.delegate?.reloadTableView()
                    break
                case .error(let error):
                    if let _ = weakself.characters {
                        weakself.characters!.data.count = weakself.characters?.data.total ?? 0
                    }
                    weakself.delegate?.reloadTableView()
                    weakself.delegate?.errorService(error: error)
                    break
            }
        }
    }
    
    func fetchDataDetailCharacter(index: Int) {
        reloadArrowSection()
        if let _ = characters?.data.results[index].detailCharacter {
            delegate?.detailCharacter(index: index)
        } else {
            serviceHandler.getDetailCharacter(characterId: String(characters?.data.results[index].id ?? 0)) { [weak self] (response) in
               guard let weakself = self else { return }
               switch response {
                   case .success(let detailCharacter):
                        if let detailCharacter = detailCharacter {
                            weakself.characters?.data.results[index].detailCharacter = detailCharacter
                            weakself.delegate?.detailCharacter(index: index)
                            weakself.setPreferences()
                        }
                        break
                   case .error(let error):
                        weakself.delegate?.errorService(error: error)
                        break
               }
           }
        }
    }
    
    func downloadImagen(image: UIImageView, activityIndicator: UIActivityIndicatorView, index: Int) {
        serviceHandler.getImageCharacter(url: getURLImage(index: index) ?? "") { [weak self] (response) in
            guard let weakself = self else { return }
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            switch response {
                case .success(let imageData):
                     if let imageData = imageData {
                        weakself.characters?.data.results[index].image = imageData
                        image.isHidden = false
                        image.image = imageData
                     }
                     weakself.setPreferences()
                     break
                case .error(_):
                    image.image = UIImage(named: "marvel")
                     break
            }
        }
    }
    
    func getNumberOfCharacters() -> Int? {
        return characters?.data.results.count
    }
    
    func getNameOfCharacters(index: Int) -> String? {
        return characters?.data.results[index].name
    }
    
    func getImageCharacter(index: Int) -> UIImage? {
        return characters?.data.results[index].image
    }
    
    func isPagination() -> Bool {
        return characters?.data.count ?? 0 < characters?.data.total ?? 0
    }
    
    func getNameDetail(index: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].name
    }
    
    func getDescriptionDetail(index: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].description
    }
    
    func getNumberOfComics(index: Int) -> Int? {
        if arrowSection[1] ?? false {
            return characters?.data.results[index].detailCharacter?.data.results[0].comics.items.count
        } else {
            return 0
        }
    }
    
    func getTitleOfComics(index: Int, indexRow: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].comics.items[indexRow].name
    }
    
    func getNumberOfStories(index: Int) -> Int? {
        if arrowSection[2] ?? false {
            return characters?.data.results[index].detailCharacter?.data.results[0].stories.items.count
        } else {
            return 0
        }
    }
    
    func getTitleOfStories(index: Int, indexRow: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].stories.items[indexRow].name
    }
    
    func getNumberOfEvents(index: Int) -> Int? {
        if arrowSection[3] ?? false {
            return characters?.data.results[index].detailCharacter?.data.results[0].events.items.count
        } else {
            return 0
        }
    }
    
    func getTitleOfEvents(index: Int, indexRow: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].events.items[indexRow].name
    }
    
    func getNumberOfUrls(index: Int) -> Int? {
        if arrowSection[4] ?? false {
            return characters?.data.results[index].detailCharacter?.data.results[0].urls.count
        } else {
            return 0
        }
    }
    
    func getTitleOfUrls(index: Int, indexRow: Int) -> String? {
        return characters?.data.results[index].detailCharacter?.data.results[0].urls[indexRow].url
    }
    
    func arrowClicked(_ section: Int) {
        arrowSection[section] = !(arrowSection[section] ?? true)
    }
    
    func getArrowDirection(_ section: Int) -> Bool {
        return arrowSection[section] ?? false
    }
}

//MARK: - private methods -
extension CharactersViewModel {
    private func setPreferences() {
        do {
            let data = try JSONEncoder().encode(characters)
            UserPreferences.shared.save(object: data, forKey: UserPreferences.Key.charactersMarvel)
        } catch {
            UserPreferences.shared.delete(forKey: UserPreferences.Key.charactersMarvel)
        }
    }
    
    private func getURLImage(index: Int) -> String? {
        return (characters?.data.results[index].thumbnail.path ?? "") + "." + (characters?.data.results[index].thumbnail.thumbnailExtension ?? "")
    }
    
    private func reloadArrowSection() {
        arrowSection = [1: false, 2: false, 3: false, 4: false]
    }
}
