//
//  MainViewController.swift
//  test-task
//
//  Created by Александр on 16.03.2022.
//

import UIKit
import SnapKit
class MainViewController: UIViewController {
//MARK: -Properties
    private var cellID = "cells"
    private var array = [FilmsViewModel]()
    private var copyArray = [FilmsViewModel]()
    private var cells = 10000
//MARK: -Views
    private lazy var collection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        collection.backgroundColor = .white
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private lazy var label : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Films"
        label.textColor = .black
        label.center = view.center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.register(FilmsCells.self, forCellWithReuseIdentifier: cellID)
            load()
        delegate()
        setupViews()
        setupConstraints()
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: cells/2, section: 0)
        collection.scrollToItem(at: indexPath, at: .left, animated: true)
    }
//MARK: -Private methods
    private func delegate() {
        collection.delegate = self
        collection.dataSource = self
    }
    private func setupViews() {
        view.addSubview(label)
        view.addSubview(collection)
        view.backgroundColor = .white
        self.title = "all fillms"
    }
   private func load() {
        let url = URL(string: "https://imdb-api.com/API/Search/k_6hekvavf/films")
        Service.shared.infoLoad(url: url!, responce: {[weak self] info, error in
            if error == nil {
                guard let info = info else { return}
                self?.array = info.results
                self?.copyArray = self!.array
                self?.collection.reloadData()
                print("Done")
            }
            else {
                print(error!.localizedDescription)}
        })
    }
    private func setupConstraints() {
        label.snp.makeConstraints{maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.centerX.equalTo(view)
            collection.snp.makeConstraints{maker in
                maker.left.right.equalTo(view)
                maker.bottom.equalTo(label).offset(400)
                maker.height.equalTo(350)
            }
        }
    }
}
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? FilmsCells
        if self.copyArray.count != 0 {
            let viewModel = self.copyArray[indexPath.row % self.copyArray.count]
            cell?.configure(viewModel)
        }
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let new = InfoViewController()
        new.configure(array, number: indexPath.row % self.copyArray.count)
        self.navigationController?.pushViewController(new, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
}
