//
//  WaterfallCollectionViewLayout.swift
//  Settings
//
//  Created by ChangLiu on 2022/3/20.
//

import UIKit

enum Column: Int {
    case One = 1
    case Two
    case Three
    case Five
    case Ten = 10
}

protocol WaterfallCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForItem at: IndexPath)->CGSize
}

class WaterfallCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: WaterfallCollectionViewLayoutDelegate?
    var column: Column {
        didSet {
            prepare()
        }
    }
    
    var cellWidth: CGFloat {
        get {(contentWith - CGFloat(column.rawValue - 1) * lineSpacing) / CGFloat(column.rawValue)}
        set {}
    }
    
    private var lineSpacing: CGFloat
    private var columnSpacing: CGFloat
    
    init(lineSpacing: CGFloat, columnSpacing: CGFloat, column: Column) {
        self.lineSpacing = lineSpacing
        self.columnSpacing = columnSpacing
        self.column = column
        super.init()
    }
    
    convenience override init() {
        self.init(lineSpacing: 2, columnSpacing: 2, column: .Two)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var heightForEachColumn: [CGFloat] = Array(repeating: 0, count: column.rawValue)

    private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    private var contentWith: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
    }
    
    private var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWith, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.values.filter({ $0.frame.intersects(rect) })
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        heightForEachColumn = Array(repeating: 0, count: column.rawValue)
        
        var xOrigin: CGFloat = 0
        var yOrigin: CGFloat = 0
        var columnCount: Int = 0
        
        for section in 0 ..< collectionView.numberOfSections {
            for row in 0 ..< collectionView.numberOfItems(inSection: section){
                let indexPath = IndexPath(row: row, section: section)
                let itemSize = delegate?.collectionView(collectionView, sizeForItem: indexPath) ?? CGSize(width: (contentWith - CGFloat(column.rawValue - 1) * lineSpacing) / CGFloat(column.rawValue), height: 50)
                
                let frame = CGRect(x: xOrigin, y: yOrigin, width: itemSize.width, height: itemSize.height)
                heightForEachColumn[columnCount] = heightForEachColumn[columnCount] + itemSize.height + columnSpacing
                
                let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attributes.frame = frame
                cache[indexPath] = attributes
                
                columnCount += 1
                if columnCount >= column.rawValue {
                    columnCount = 0
                    xOrigin = 0
                } else {
                    xOrigin += itemSize.width + lineSpacing
                }
                yOrigin = heightForEachColumn[columnCount]
            }
        }
        contentHeight = heightForEachColumn.max() ?? 0
    }
}
