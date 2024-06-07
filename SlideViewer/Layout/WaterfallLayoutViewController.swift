//
//  WaterfallLayoutViewController.swift
//  Settings
//
//  Created by ChangLiu on 2022/3/20.
//

import UIKit
import AVFoundation
import SwiftUI

class WaterfallLayoutViewController: UIViewController {
    private var importImageViewModel: ProfileModel
    private var posts: [Post] = []
    private var column: Column = .Two {
        didSet {
            collectionLayout.column = column
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionLayout: WaterfallCollectionViewLayout = {
        let layout = WaterfallCollectionViewLayout(lineSpacing: 5, columnSpacing: 5, column: column)
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        return collectionView
    }()
    
    init(importImageViewModel: ProfileModel) {
        self.importImageViewModel = importImageViewModel
        super.init(nibName: nil, bundle: nil)
        self.importImageViewModel.delegate = self
        posts = importImageViewModel.importedImages.map({ return Post(postId: UUID().uuidString,images: [$0]) })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.title = "Collection"
        addConstraint()
        addGestureRecognizer()
              
        print(AVCaptureDevice.DiscoverySession(deviceTypes: [
            .builtInWideAngleCamera,
            .builtInTelephotoCamera,
            .builtInTrueDepthCamera,
            .builtInTelephotoCamera
        ],
        mediaType: .video,
        position: .unspecified).devices.count)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear")
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func setPost(posts: [Post]) {
        self.posts = posts
        collectionView.reloadData()
    }
    
    private func addConstraint() {
        var customConstraints: [NSLayoutConstraint] = []
        customConstraints.append(collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        customConstraints.append(collectionView.topAnchor.constraint(equalTo: view.topAnchor))
        customConstraints.append(collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        customConstraints.append(collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(customConstraints)
    }
    
    @objc private func didPintch(_  gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .ended:
            if gesture.scale >= 1.2 {
                column = Column(rawValue: column.rawValue - 1) ?? .One
            } else if gesture.scale <= 0.8 {
                column =  Column(rawValue: column.rawValue + 1) ?? .Ten
            }
        default:
            return
        }
    }
    
    private func addGestureRecognizer() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPintch(_:)))
        view.addGestureRecognizer(pinchGestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    private func convertColumnToCellMode(column: Column, post: Post) -> PostCellMode {
        if post.title.isEmpty {
            return .ImageOnly
        }
        switch column {
        case .One, .Two:
            return .Full
        case .Three, .Five, .Ten:
            return .ImageOnly
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    posts.remove(at: sourceIndexPath.row)
                    posts.insert(item.dragItem.localObject as! Post, at: destinationIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}

extension WaterfallLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell ?? PostCell(frame: .zero)
        cell.configure(post: post, mode: convertColumnToCellMode(column: column, post: post))
        return cell
    }
}

extension WaterfallLayoutViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = posts[indexPath.row].images.first {
            importImageViewModel.updateImageState(imageState: .success(Image(uiImage: image)))
        }
    }
}

extension WaterfallLayoutViewController: WaterfallCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItem at: IndexPath) -> CGSize {
        let post = posts[at.row]
        return post.calculateCellSize(collectionLayout: collectionLayout)
    }
}

//drag and drop
extension WaterfallLayoutViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let post = posts[indexPath.row]
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = post
        return [dragItem]
    }
}

extension WaterfallLayoutViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: row - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
}

extension WaterfallLayoutViewController: ImportImageViewModelDelegate {
    func didupdateList(_ viewModel: ProfileModel, list: [UIImage]) {
        posts = importImageViewModel.importedImages.map({ return Post(postId: UUID().uuidString,images: [$0]) })
        collectionView.reloadData()
    }
}
