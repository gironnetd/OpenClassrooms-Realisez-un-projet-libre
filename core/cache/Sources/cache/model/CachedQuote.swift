//
//  CachedQuote.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a quote
 */
public class CachedQuote: Object {
    
    @Persisted(primaryKey: true) var idQuote: Int
    @Persisted var idAuthor: Int?
    @Persisted var idBook: Int?
    @Persisted var quote: String
    @Persisted var source: String?
    @Persisted var reference: String?
    @Persisted var remarque: String?
    @Persisted var comment: String?
    @Persisted var commentName: String?
    
    public init(idQuote: Int,
                idAuthor: Int? = nil,
                idBook: Int? = nil,
                quote: String,
                source: String? = nil,
                reference: String? = nil,
                remarque: String? = nil,
                comment: String? = nil,
                commentName: String? = nil) {
        super.init()
        self.idQuote = idQuote
        self.idAuthor = idAuthor
        self.idBook = idBook
        self.quote = quote
        self.source = source
        self.reference = reference
        self.remarque = remarque
        self.comment = comment
        self.commentName = commentName
    }
}

extension CachedQuote {

    func asExternalModel() -> Quote {
        return Quote(idQuote: idQuote,
                           idAuthor: idAuthor,
                           idBook: idBook,
                           quote: quote,
                           source: source,
                           reference: reference,
                           remarque: remarque,
                           comment: comment,
                           commentName: commentName)
    }
}
