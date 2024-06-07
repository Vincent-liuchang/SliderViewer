//
//  PostContentViewController.swift
//  Settings
//
//  Created by Vincent Liu on 2022/9/16.
//

import UIKit

protocol PostContentViewControllerProtocol: AnyObject {
    
}

class PostContentViewController: UIViewController, PostContentViewControllerProtocol {
    private struct Constants {
        static let topBarHeight: CGFloat = 50
        static let avatarSize: CGFloat = 30
        static let padding: CGFloat = 5
    }
    
    var postContent: Post = Post(images: [UIImage(named: "image4") ?? UIImage()])
    
    //Top Bar
    private lazy var topBarView: UIView = {
        let topBarView = UIView(frame: .zero)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(topLeftStackView)
        return topBarView
    }()
    
    private lazy var topLeftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarView, nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.avatarSize/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vincent"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    //Middle Content
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var collectionLayout: WaterfallCollectionViewLayout = {
        let layout = WaterfallCollectionViewLayout(lineSpacing: 5, columnSpacing: 5, column: .One)
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        return collectionView
    }()
    
    //Container
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(topBarView)
        scrollView.addSubview(middleStackView)
        return scrollView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        addConstraint()
        applyTheme()
        userActivity = NSUserActivity(activityType: "Test")
        userActivity?.title = "Test"
    }
    
    private func addConstraint() {
        var customConstraints: [NSLayoutConstraint] = []
        customConstraints.append(scrollView.topAnchor.constraint(equalTo: view.topAnchor))
        customConstraints.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        customConstraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        customConstraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        customConstraints.append(topBarView.topAnchor.constraint(equalTo: scrollView.topAnchor))
        customConstraints.append(topBarView.widthAnchor.constraint(equalTo: scrollView.widthAnchor))
        customConstraints.append(topBarView.heightAnchor.constraint(equalToConstant: Constants.topBarHeight))
        
        customConstraints.append(topLeftStackView.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: Constants.padding))
        customConstraints.append(topLeftStackView.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor))
        customConstraints.append(avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarSize))
        customConstraints.append(avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarSize))
        
        customConstraints.append(middleStackView.topAnchor.constraint(equalTo: topBarView.bottomAnchor))
        customConstraints.append(middleStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.padding))
        customConstraints.append(middleStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.padding))
        
        customConstraints.append(collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Constants.padding * 2))
        customConstraints.append(collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400))
        
        NSLayoutConstraint.activate(customConstraints)
    }
    
    private func applyTheme() {
        avatarView.tintColor = .black
        avatarView.backgroundColor = .green
        topBarView.backgroundColor = .gray
        view.backgroundColor = .white
    }
}

extension PostContentViewController: WaterfallCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItem at: IndexPath) -> CGSize {
        return postContent.calculateCellSize(collectionLayout: collectionLayout)
    }
}

extension PostContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension PostContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postContent.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell ?? PostCell(frame: .zero)
        cell.configure(post: postContent, mode: .ImageOnly)
        return cell
    }
}
