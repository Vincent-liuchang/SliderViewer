//
//  Post.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/9.
//

import UIKit

class Post {
    init(postId: String = "", title: String = "", images: [UIImage] = [], content: String = "", description: String = "", author: String = "", date: Date = Date(), likes: Int = 0, boardData: [Bill] = [], boradType: BoardType = .Unknown) {
        self.postId = postId
        self.title = title
        self.images = images
        self.content = content
        self.description = description
        self.author = author
        self.date = date
        self.likes = likes
        self.boardData = boardData
        self.boardType = boradType
    }
    
    var postId: String = ""
    var title: String = ""
    var images: [UIImage] = []
    var content: String = ""
    var description: String = ""
    var author: String = ""
    var date: Date = Date()
    var likes: Int = 0
    var boardData: [Bill] = []
    var boardType: BoardType = .Unknown
    
}

enum PostCellMode {
    case ImageOnly
    case TextOnly
    case Full
    case Preview
}

enum BoardType {
    case Unknown
    case Line
    case Bar
    case Point
    case Pie
}

extension Post {
    func calculateCellSize(collectionLayout: WaterfallCollectionViewLayout) -> CGSize {
        let width = collectionLayout.cellWidth
        var height = width
        let hideDescription = title.isEmpty || collectionLayout.column.rawValue >= 3
        if let image = images.first {
            height = image.size.height / image.size.width * width + ( hideDescription ? 0 : 50)
        } else {
            height = 50
        }
        return CGSize(width: width, height: height)
    }
}
