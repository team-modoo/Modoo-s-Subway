//
//  CardViewEntity.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import Foundation

struct CardViewEntity: Codable, Identifiable, Equatable {
	let id: UUID
	let lineName: String
	let lineNumber: String
	var arrivalMessage: String
	var isExpress: String
	var arrivals: [Arrival]
	var stationName: String
	var stationNames: [String]
	var upDownLine: String
	var isStar: Bool // MARK: - 즐겨찾기 여부
	var isFolder: Bool // MARK: - 폴더 여부
	
	init(id: UUID = UUID(),
		 lineName: String,
		 lineNumber: String,
		 arrivalMessage: String,
		 isExpress: String,
		 arrivals: [Arrival],
		 stationName: String,
		 stationNames: [String],
		 upDownLine: String,
		 isStar: Bool = false,
		 isFolder: Bool = false) {
		self.id = id
		self.lineName = lineName
		self.lineNumber = lineNumber
		self.arrivalMessage = arrivalMessage
		self.isExpress = isExpress
		self.arrivals = arrivals
		self.stationName = stationName
		self.stationNames = stationNames
		self.upDownLine = upDownLine
		self.isStar = isStar
		self.isFolder = isFolder
	}
}

struct Arrival: Codable, Identifiable, Hashable, Equatable {
	let id: UUID
	let arrivalCode: String
	let station: String
	let trainLineName: String
	
	init(id: UUID = UUID(),
		 arrivalCode: String,
		 station: String,
		 trainLineName: String) {
		self.id = id
		self.arrivalCode = arrivalCode
		self.station = station
		self.trainLineName = trainLineName
	}
}
