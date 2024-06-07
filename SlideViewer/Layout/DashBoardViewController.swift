//
//  DashBoardViewController.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/9.
//

import UIKit
import SwiftUI
import AVFoundation

class DashBoardViewController: UIViewController {
    private var posts: [Post] = []
    private var column: Column = .One {
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let data: [Bill] = [
            Bill(id: 0, name: "Sept", type: .Incoming, category: .eating, value: 20000),
            Bill(id: 1, name: "Aug", type: .Incoming, category: .eating, value: 7000),
            Bill(id: 2, name: "Nov", type: .Incoming, category: .living, value: 9000),
            Bill(id: 3, name: "Dec", type: .Incoming, category: .living, value: 18000),
            
            Bill(id: 4, name: "Sept", type: .Outgoing, category: .living, value: -1000),
            Bill(id: 5, name: "Aug", type: .Outgoing, category: .living, value: -3000),
            Bill(id: 6, name: "Nov", type: .Outgoing, category: .living, value: -9000),
            Bill(id: 7, name: "Dec", type: .Outgoing, category: .living, value: -10000)
        ]
        posts = [Post(boardData: data, boradType: .Bar),
                 Post(boardData: data, boradType: .Line),
                 Post(boardData: data, boradType: .Point),
                 Post(boardData: [Bill(id: 0, name: "Sept", type: .Incoming, category: .eating, value: 20000),
                                  Bill(id: 1, name: "Aug", type: .Incoming, category: .eating, value: 7000),
                                  Bill(id: 2, name: "Nov", type: .Incoming, category: .living, value: 9000),
                                  Bill(id: 3, name: "Dec", type: .Incoming, category: .living, value: 18000)], boradType: .Pie)]
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

extension DashBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell ?? PostCell(frame: .zero)
        cell.contentConfiguration =  getContentConfiguration(post: post)
        return cell
    }
    
    private func getContentConfiguration(post: Post) -> UIContentConfiguration {
        switch post.boardType {
        case .Bar:
            return UIHostingConfiguration {
                BarChartCell(data: post.boardData)
            }
            .margins(.all, 0)
        case .Line:
            return UIHostingConfiguration {
                LineChartCell(data: post.boardData)
            }
            .margins(.all, 0)
        case .Point:
            return UIHostingConfiguration {
               PointChartCell(data: post.boardData)
            }
            .margins(.all, 0)
        case .Pie:
            return UIHostingConfiguration {
                if #available(iOS 17.0, *) {
                    PieChartCell(data: post.boardData)
                }
            }
            .margins(.all, 0)
        default:
            return UIHostingConfiguration {
            }
            .margins(.all, 0)
        }
    }
}

extension DashBoardViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension DashBoardViewController: WaterfallCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItem at: IndexPath) -> CGSize {
        return CGSize(width: collectionLayout.cellWidth, height:  collectionLayout.cellWidth)
    }
}

//drag and drop
extension DashBoardViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let post = posts[indexPath.row]
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = post
        return [dragItem]
    }
}

extension DashBoardViewController: UICollectionViewDropDelegate {
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
