//
//  SettingCell.swift
//  modoosSubway
//
//  Created by 김지현 on 12/15/24.
//

import SwiftUI

struct SettingCell: View {
	@State private var isOn = true
	@AppStorage private var toggleState: Bool
	@Binding var showAlert: Bool
	private let isSection1: Bool
	private let title: String
	private let toggleType: SettingToggleType
	private let infoType: InformationType
	private let destination: String
	
	init(isSection1: Bool, title: String, toggleType: SettingToggleType, showAlert: Binding<Bool>) {
		self.isSection1 = isSection1
		self.title = title
		self._toggleState = AppStorage(wrappedValue: false, "setting_toggle_\(toggleType.rawValue)")
		self.toggleType = toggleType
		self.infoType = .version // Default value
		self.destination = ""
		self._showAlert = showAlert
	}
	
	init(isSection1: Bool, title: String, destination: String? = nil, infoType: InformationType, showAlert: Binding<Bool>) {
		self.isSection1 = isSection1
		self.title = title
		self._toggleState = AppStorage(wrappedValue: true, "dummy_key")
		self.toggleType = .notification // Default value
		self.infoType = infoType
		self.destination = destination ?? ""
		self._showAlert = showAlert
	}
	
	var body: some View {
		if isSection1 {
			toggleSection
		} else {
			infoSection
		}
	}
	
	private var toggleSection: some View {
		HStack {
			Text(title)
				.font(.pretendard(size: 16, family: .medium))
				.foregroundStyle(.black)
			
			Spacer()
			
			Toggle(isOn: $toggleState) {
					// EmptyView()
			}
			.onChange(of: toggleState) { _ , newValue in
				handleToggleChange(newValue)
			}
		}
		.frame(height: 30)
		.background(.white)
	}
	
	private var infoSection: some View {
		Group {
			switch infoType {
			case .version:
				versionView
			case .privacy, .terms:
				privacyAndTermsView
			}
		}
	}
	
	private var versionView: some View {
		HStack {
			Text(title)
				.font(.pretendard(size: 16, family: .medium))
				.foregroundStyle(.black)
			
			Spacer()
			
			Text("v \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
				.font(.pretendard(size: 14, family: .semiBold))
				.foregroundStyle(.BFBFBF)
		}
		.frame(height: 30)
		.background(.white)
	}
	
	private var privacyAndTermsView: some View {
		Button(action: {
			print("")
		}) {
			Link(destination: URL(string: destination)!) {
				HStack {
					Text(title)
						.font(.pretendard(size: 16, family: .medium))
						.foregroundStyle(.black)
					
					Spacer()
					
					Image(.iconChevronRight)
				}
				.frame(height: 30)
				.background(.white)
			}
		}
	}
	
	private func handleToggleChange(_ newValue: Bool) {
		print("\(title) 토글 상태 변경: \(newValue)")
		showAlert = true
	}
}
