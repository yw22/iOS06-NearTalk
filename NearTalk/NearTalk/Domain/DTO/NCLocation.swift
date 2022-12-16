//
//  NCLocation.swift
//  NearTalk
//
//  Created by 고병학 on 2022/11/17.
//

import Foundation

struct NCLocation: Codable, Hashable {
    // 강남역
    static let gangnamStation: NCLocation = .init(latitude: 37.497954687223526, longitude: 127.02761650085449)
    // 판교역
    static let pangyoStation: NCLocation = .init(latitude: 37.394904, longitude: 127.111337)
    // 네이버 1784
    static let naver: NCLocation = .init(latitude: 37.375281, longitude: 127.106536)

    // 미터 당 위경도
    static let decimalDegreePerMeter: Double = 0.000009009 // 도/m
    static let meterPerDecimalDegree: Double = 111000 // m/도
    
    var latitude: Double
    var longitude: Double
    
    /// http://wiki.gis.com/wiki/index.php/Decimal_degrees
    func add(latitudeMeters: Double, longitudeMeters: Double) -> NCLocation {
        return NCLocation(latitude: self.latitude + (latitudeMeters * Self.decimalDegreePerMeter),
                          longitude: self.longitude + (longitudeMeters * Self.decimalDegreePerMeter))
    }
    
    func add(latitudeDelta: Double, longitudeDelta: Double) -> NCLocation {
        return NCLocation(latitude: self.latitude + latitudeDelta,
                          longitude: self.longitude + longitudeDelta)
    }
    
    func distance(from location: NCLocation) -> Double {
        let latitudeDeltaMeters = abs(self.latitude - location.latitude) * Self.meterPerDecimalDegree
        let longitudeDeltaMeters = abs(self.longitude - location.longitude) * Self.meterPerDecimalDegree
        
        return sqrt(pow(latitudeDeltaMeters, 2) + pow(longitudeDeltaMeters, 2))
    }
}
