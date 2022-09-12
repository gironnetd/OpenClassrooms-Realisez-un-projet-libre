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
    
    @Persisted(primaryKey: true) var idPresentation: Int
    @Persisted var presentation: String?
    @Persisted var presentationTitle1: String?
    @Persisted var presentation1: String?
    @Persisted var presentationTitle2: String?
    @Persisted var presentation2: String?
    @Persisted var presentationTitle3: String?
    @Persisted var presentation3: String?
    @Persisted var presentationTitle4: String?
    @Persisted var presentation4: String?
    @Persisted var sourcePresentation: String?
    
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
}

extension CachedPresentation {
    
    func asExternalModel() -> Presentation {
        return Presentation(idPresentation: idPresentation,
                                  presentation: presentation,
                                  presentationTitle1: presentationTitle1,
                                  presentation1: presentation1,
                                  presentationTitle2: presentationTitle2,
                                  presentation2: presentation2,
                                  presentationTitle3: presentationTitle3,
                                  presentation3: presentation3,
                                  presentationTitle4: presentationTitle4,
                                  presentation4: presentation4,
                                  sourcePresentation: sourcePresentation)
    }
}
