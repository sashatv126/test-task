//
//  InfoViewController.swift
//  test-task
//
//  Created by Александр on 16.03.2022.
//

import UIKit
class InfoViewController: UIViewController {
//MARK: -Views
    private lazy var stackView : UIStackView = {
          let stack = UIStackView()
           stack.axis = .vertical
           stack.distribution = .fillEqually
           stack.spacing = 16
           return stack
       }()
    private lazy var filmImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .red
        return image
    }()
    private lazy var labelInfo : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
         label.text = "Films"
         label.textColor = .black
         label.center = view.center
         return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
//MARK: -Private methods
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(filmImage)
        stackView.addArrangedSubview(labelInfo)
        view.backgroundColor = .white
    }
    func configure(_ array : [FilmsViewModel],number : Int) {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        let date = Date()
        if let url = URL(string : array[number].image) {
            Service.shared.urlSeesionload(url: url , completion: { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.filmImage.image = image
                    self?.labelInfo.text = "Day download: \(formater.string(from:date))"
                case .failure(let error):
                    print("\(error.localizedDescription) OFFLINE mode activation")
                    let image = UIImage(data: DataBase.shared.loadData())
                    self?.filmImage.image = image
                }
            })
        }
    }
    private func setupConstraints() {
        stackView.snp.makeConstraints{maker in
            maker.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            maker.left.right.equalTo(view).inset(20)
        }
        filmImage.snp.makeConstraints{maker in
            maker.top.equalTo(stackView).inset(100)
        }
        labelInfo.snp.makeConstraints{maker in
            maker.bottom.equalTo(stackView)
        }
    }
}
