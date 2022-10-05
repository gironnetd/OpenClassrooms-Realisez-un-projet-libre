//
//  File.swift
//  
//
//  Created by damien on 28/09/2022.
//

import Foundation

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
  init?(dictionary: [String: Any])
}
