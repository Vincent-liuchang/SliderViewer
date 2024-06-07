//
//  PostCell.swift
//  Settings
//
//  Created by ChangLiu on 2022/3/20.
//

import UIKit

class PostCell: UICollectionViewCell {
    func configure(post: Post, mode: PostCellMode = .Full){
        self.post = post
        self.mode = mode
    }
    
    var mode: PostCellMode = .Full {
        didSet {
            postInfoConstraints.constant = 50
            switch mode {
            case .Full : hideOrShowAllViews(hidden: false)
            case .Preview: postInfoStack.isHidden = false
            case .ImageOnly: imageView.isHidden = false; postInfoConstraints.constant = 0
            case .TextOnly: postInfoStack.isHidden = false
            }
        }
    }
    
    static let reuseIdentifier = "SwitchCell"
    
    private var post: Post? {
        didSet {
            imageView.image = post?.images.first
            titileLabel.text = post?.title
            authorLabel.text = post?.author
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titileLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var postInfoStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titileLabel, authorLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.isHidden = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, postInfoStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.isHidden = false
        return stackView
    }()
    
    private lazy var postInfoConstraints: NSLayoutConstraint = postInfoStack.heightAnchor.constraint(equalToConstant: 50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        addConstraint()
        applyTheme()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("This subclass does not support NSCoding.")
    }
    
    override func prepareForReuse() {
        hideOrShowAllViews(hidden: true)
    }
    
    private func hideOrShowAllViews(hidden: Bool) {
        imageView.isHidden = hidden
        titileLabel.isHidden = hidden
        postInfoStack.isHidden = hidden
    }
    
    private func addConstraint() {
        var customConstraints: [NSLayoutConstraint] = []
        customConstraints.append(contentsOf: [
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: postInfoStack.topAnchor),
            postInfoConstraints
        ])
        NSLayoutConstraint.activate(customConstraints)
    }
    
    private func applyTheme() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        authorLabel.textColor = .secondaryLabel
    }
}
