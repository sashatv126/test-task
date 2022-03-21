//
//  Films.swift
//  test-task
//
//  Created by Александр on 16.03.2022.
//

import UIKit
import SnapKit
class FilmsCells: UICollectionViewCell {
//MARK: -Properties
    static let cellidentifier = "cell with films"
//MARK: -Views
    private lazy var filmImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    private lazy var label : UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
//MARK: -Init
    override init(frame : CGRect) {
        super.init(frame: frame)
        addSubview(filmImage)
        addSubview(label)
        constraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: -Public methods
    func configure(_ viewModel : FilmsViewModel){
        if let url = URL(string : viewModel.image) {
            Service.shared.urlSeesionload(url: url , completion: { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.filmImage.image = image
                    print("Done")
                case .failure(let error):
                    print("\(error.localizedDescription) OFFLINE mode activation")
                    let image = UIImage(data: DataBase.shared.loadData())
                    self?.filmImage.image = image
                }
            })
        }
        label.text = viewModel.title
    }
//MARK: -Private methods
    private func constraints() {
        filmImage.snp.makeConstraints{maker in
            maker.top.equalTo(contentView).inset(50)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(200)
        }
        label.snp.makeConstraints{maker in
            maker.left.right.equalTo(contentView)
            maker.bottom.equalTo(filmImage).offset(70)
            maker.height.equalTo(50)
            maker.width.equalTo(150)
        }
    }
}

