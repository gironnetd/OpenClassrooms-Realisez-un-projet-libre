//
//  CachedPresentation.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

/**
 * Model used solely for the caching of a presentation
 */
public class CachedPresentation: Object {
    
    @Persisted(primaryKey: true) public var idPresentation: Int
    @Persisted public var presentation: String?
    @Persisted public var presentationTitle1: String?
    @Persisted public var presentation1: String?
    @Persisted public var presentationTitle2: String?
    @Persisted public var presentation2: String?
    @Persisted public var presentationTitle3: String?
    @Persisted public var presentation3: String?
    @Persisted public var presentationTitle4: String?
    @Persisted public var presentation4: String?
    @Persisted public var sourcePresentation: String?
    
    public override init() {}
    
    public init(idPresentation: Int,
                presentation: String? = nil,
                presentationTitle1: String? = nil,
                presentation1: String? = nil,
                presentationTitle2: String? = nil,
                presentation2: String? = nil,
                presentationTitle3: String? = nil,
                presentation3: String? = nil,
                presentationTitle4: String? = nil,
                presentation4: String? = nil,
                sourcePresentation: String? = nil) {
        super.init()
        self.idPresentation = idPresentation
        self.presentation = presentation
        self.presentationTitle1 = presentationTitle1
        self.presentation1 = presentation1
        self.presentationTitle2 = presentationTitle2
        self.presentation2 = presentation2
        self.presentationTitle3 = presentationTitle3
        self.presentation3 = presentation3
        self.presentationTitle4 = presentationTitle4
        self.presentation4 = presentation4
        self.sourcePresentation = sourcePresentation
    }
    
    public convenience init?(idPresentation: Int) {
        guard let presentation = try? Realm().objects(CachedPresentation.self).where({ presentation in presentation.idPresentation == idPresentation }).first else {
            return nil
        }
        
        self.init(idPresentation: presentation.idPresentation,
                  presentation: presentation.presentation,
                  presentationTitle1: presentation.presentationTitle1,
                  presentation1: presentation.presentation1,
                  presentationTitle2: presentation.presentationTitle2,
                  presentation2: presentation.presentation2,
                  presentationTitle3: presentation.presentationTitle3,
                  presentation3: presentation.presentation3,
                  presentationTitle4: presentation.presentationTitle4,
                  presentation4: presentation.presentation4,
                  sourcePresentation: presentation.sourcePresentation)
    }
}

extension CachedPresentation {
    
    public func asExternalModel() -> Presentation {
        Presentation(idPresentation: self.idPresentation,
                     presentation: self.presentation,
                     presentationTitle1: self.presentationTitle1,
                     presentation1: self.presentation1,
                     presentationTitle2: self.presentationTitle2,
                     presentation2: self.presentation2,
                     presentationTitle3: self.presentationTitle3,
                     presentation3: self.presentation3,
                     presentationTitle4: self.presentationTitle4,
                     presentation4: self.presentation4,
                     sourcePresentation: self.sourcePresentation)
    }
}

extension Presentation {
    
    public func asCached() -> CachedPresentation {
        CachedPresentation(idPresentation: self.idPresentation,
                           presentation: self.presentation,
                           presentationTitle1: self.presentationTitle1,
                           presentation1: self.presentation1,
                           presentationTitle2: self.presentationTitle2,
                           presentation2: self.presentation2,
                           presentationTitle3: self.presentationTitle3,
                           presentation3: self.presentation3,
                           presentationTitle4: self.presentationTitle4,
                           presentation4: self.presentation4,
                           sourcePresentation: self.sourcePresentation)
    }
}
