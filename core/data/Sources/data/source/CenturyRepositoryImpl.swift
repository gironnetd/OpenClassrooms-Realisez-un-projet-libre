//
//  File.swift
//  
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache

public class CenturyRepositoryImpl: CenturyRepository {
    
    private let centuryDao: CenturyDao
    
    public init() {
        centuryDao = CenturyDaoImpl()
    }
    
    /// Retrieve a century from its identifier
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdCentury idCentury: Int) -> AnyPublisher<Century, Error> {
        centuryDao.findCentury(byIdCentury: idCentury).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }

    /// Retrieve a century from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdAuthor idAuthor: Int) -> AnyPublisher<Century, Error> {
        centuryDao.findCentury(byIdAuthor: idAuthor).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a century from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdBook idBook: Int) -> AnyPublisher<Century, Error> {
        centuryDao.findCentury(byIdBook: idBook).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a century from its name
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byName name: String) -> AnyPublisher<Century, Error> {
        centuryDao.findCentury(byName: name).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all centuries
    ///
    /// - Returns: An AnyPublisher returning an Array of Century or an Error
    public func findAllCenturies() -> AnyPublisher<[Century], Error> {
        centuryDao.findAllCenturies().map { centuries in
            centuries.map { century in century.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
