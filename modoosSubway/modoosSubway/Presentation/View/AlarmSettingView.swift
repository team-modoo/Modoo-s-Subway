//
//  AlarmSettingView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/15/24.
//

import SwiftUI

struct AlarmSettingView: View {
    @AppStorage private var alarmToggleState: Bool
    let section1: [AlarmSettingType] = [.timeSetting, .daySetting, .repeatSetting]
    @State private var expandedCell: AlarmSettingType?
    @State private var modalHeight: PresentationDetent = .fraction(3/4)
   
    
    init() {
        self._alarmToggleState = AppStorage(wrappedValue: true, "dummy_key")
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("알림 설정하기")
                    .font(.pretendard(size: 20, family: .bold))
                    .foregroundStyle(.black)
                    .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top,32)
            
            HStack {
                Text("알림")
                    .font(.pretendard(size: 16, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading, 20)
              
                Spacer()
                
                Toggle(isOn: $alarmToggleState) {
                    // EmptyView()
                }
                .padding(.trailing, 20)
                .onChange(of: alarmToggleState) { _ , newValue in
                    handleToggleChange(newValue)
                }
                
                
            }
            .padding(.horizontal,4)
            .padding(.top,16)
            
            List {
                ForEach(section1,id: \.self) { item in
                    AlarmSettingCell(title: item.rawValue, 
                                     iconName: item.iconImage(),
                                     cellType: item, 
                                     isExpanded: expandedCell == item,
                                     onTapExpand: {
                        if expandedCell == item {
                            expandedCell = nil
                            modalHeight = .fraction(3/4)
                        } else {
                            expandedCell = item
                            modalHeight = item == .timeSetting ? .large : .fraction(3/4)
                        }

                        }
                    )
                    .listRowSeparator(.automatic)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .background(.white)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .presentationDetents([modalHeight])

            Spacer()
            
            Button {
                print("폴더만들기")
            } label: {
                Text("폴더 만들기")
                    .font(.pretendard(size: 16, family: .medium))
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 16, family: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 350, height: 56)
                    .background(.green)
                    .cornerRadius(10)
            }
        }
    }
    
    private func handleToggleChange(_ newValue: Bool) {
        print("토글 상태 변경: \(newValue)")
    }
}

struct AlarmSettingCell: View {
    private var title: String
    private var iconName: String
    private var cellType: AlarmSettingType
    private var isExpanded: Bool
    private var onTapExpand: () -> Void
    @State private var selectedDate = Date()
    @State private var isAM = true
    @State private var selectedDays: Set<DaySettingView.DayType> = []
    @State private var selectedRepeatType: RepeatSettingView.RepeatedType = .none
    
    init(title: String, 
         iconName: String,
         cellType: AlarmSettingType,
         isExpanded: Bool,
         onTapExpand: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.cellType = cellType
        self.isExpanded = isExpanded
        self.onTapExpand = onTapExpand
    }
    
    
    var body: some View {
        
        VStack(spacing:0) {
            HStack {
                Image("\(iconName)")
                    .resizable()
                    .frame(width: 18,height: 18)
                
                Text("\(title)")
                    .font(.pretendard(size: 16, family: .regular))
                    .foregroundStyle(.black)
                
                Spacer()
                
                
                Button {
                    onTapExpand()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.black)
                        .frame(width: 18,height: 18)
                }
                .buttonStyle(.borderless)
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background(.white)
            
            if isExpanded {
                expandedContent
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .transition(.move(edge: .top).combined(with: .opacity))
                
            }
            
        }
    }
    
    @ViewBuilder
    private var expandedContent: some View {
        switch cellType {
        case .timeSetting:
            timeSettingView
                .frame(height: 300)
                .background(.brown)
        case .daySetting:
            DaySettingView(selectedDays: $selectedDays)
                .frame(height: 100)
        case .repeatSetting:
            RepeatSettingView(selectedRepeat: $selectedRepeatType)
                .frame(height: 120)
        }
    }
    private var timeSettingView: some View {
       
            DatePicker("", selection: $selectedDate,
                      displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
                .labelsHidden()
                .fixedSize()  // 크기 고정
                .frame(maxHeight: 250, alignment: .center)
                .clipped()  // 뷰를 프레임 내로 제한
      
    }
//    private var timeSettingView: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            DatePicker("",
//                       selection: $selectedDate,
//                       displayedComponents: [.hourAndMinute]
//            )
//            .background(.red)
//            .datePickerStyle(.wheel)
//            .labelsHidden()
//            .environment(\.locale, Locale(identifier: "ko_KR"))
//            .frame(maxWidth: .infinity)
//            .frame(height: 200)
//            .clipped()
//            .padding(.horizontal)
//        }
//
//    }
    
//    private var daySettingView: some View {
//        VStack {
//            Text("요일 설정 컨텐츠")
//                .padding()
//        }
//    }
    
    private var repeatSettingView: some View {
        VStack {
            Text("반복 설정 컨텐츠")
                .padding()
        }
    }
    
    
}

enum AlarmSettingType: String {
    case timeSetting = "시간 설정하기"
    case daySetting = "요일 설정하기"
    case repeatSetting = "반복 설정하기"
    
    func iconImage() -> String {
        switch self {
        case .timeSetting:
            return "_icon_clock"
        case .daySetting:
            return "icon_calendar"
        case .repeatSetting:
            return "icon_reload"
        }
    }
}



//struct AlarmSettingView: View {
//   @AppStorage private var alarmToggleState: Bool
//   let section1: [AlarmSettingType] = [.timeSetting, .daySetting, .repeatSetting]
//   @State private var expandedCell: AlarmSettingType?
//   @State private var modalHeight: PresentationDetent = .fraction(3/4)
//   
//   var body: some View {
//       VStack {
//           // ... 기존 코드 ...
//           
//           List {
//               ForEach(section1, id: \.self) { item in
//                   AlarmSettingCell(
//                       title: item.rawValue,
//                       iconName: item.iconImage(),
//                       cellType: item,
//                       isExpanded: expandedCell == item,
//                       onTapExpand: { [expandedCell] in // 현재 expandedCell 캡처
//                         
//                               // 현재 열린 셀이 TimeSetting이고 다른 셀을 열려고 할 때
//                               if expandedCell == .timeSetting && item != .timeSetting {
//                                   // 먼저 modal 높이를 조절하고
//                                   modalHeight = .fraction(3/4)
//                                   // 약간의 딜레이 후 셀 상태 변경
//                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                       if self.expandedCell == item {
//                                           self.expandedCell = nil
//                                       } else {
//                                           self.expandedCell = item
//                                       }
//                                   }
//                               } else {
//                                   // 그 외의 경우 일반적인 처리
//                                   if expandedCell == item {
//                                       self.expandedCell = nil
//                                       if item == .timeSetting {
//                                           modalHeight = .fraction(3/4)
//                                       }
//                                   } else {
//                                       self.expandedCell = item
//                                       if item == .timeSetting {
//                                           modalHeight = .large
//                                       }
//                                   }
//                               }
//                          
//                       }
//                   )
//               }
//           }
//       }
//       .presentationDetents([modalHeight])
//       .animation(.spring(), value: modalHeight)
//   }
//}

struct DaySettingView: View {
    @Binding var selectedDays: Set<DayType>
    
    enum DayType: String, CaseIterable {
        case mon = "월", tue = "화", wed = "수", thu = "목", fri = "금"
        case sat = "토", sun = "일", everyday = "매일"
        case weekday = "평일", weekend = "주말"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(DayType.allCases.prefix(7),id: \.self) { day in
                    DayButton(day: day, isSelected: selectedDays.contains(day)) {
                        handleDaySelection(day)
                    }
                    
                }
            }
            
            HStack {
                ForEach(DayType.allCases.suffix(3),id: \.self) { day in
                    DayButton(day: day, isSelected: selectedDays.contains(day)) {
                        handleDaySelection(day)
                    }
                    
                }
            }
        }
//        .background(.red)
        
    }
    
    private func handleDaySelection(_ day:DayType) {
        switch day {
        case .everyday:
            if selectedDays.contains(day) {
                selectedDays.remove(day)
                selectedDays.subtract([.mon, .tue, .wed, .thu, .fri, .sat, .sun])
            } else {
                selectedDays.insert(day)
                selectedDays.formUnion([.mon, .tue, .wed, .thu, .fri, .sat, .sun])
            }
        case .weekday:
            if selectedDays.contains(day) {
                selectedDays.remove(day)
                selectedDays.subtract([.mon, .tue, .wed, .thu, .fri])
            } else {
                selectedDays.insert(day)
                selectedDays.formUnion([.mon, .tue, .wed, .thu, .fri])
            }
        case .weekend:
            if selectedDays.contains(day) {
                selectedDays.remove(day)
                selectedDays.subtract([.sat, .sun])
            } else {
                selectedDays.insert(day)
                selectedDays.formUnion([.sat, .sun])
            }
            
        default:
            if selectedDays.contains(day) {
                selectedDays.remove(day)
            } else {
                selectedDays.insert(day)
            }
            
            updateGroupSelections()
        }
    }
    
    private func updateGroupSelections() {
        let weekdays: Set<DayType> = [.mon, .tue, .wed, .thu, .fri]
        let weekend: Set<DayType> = [.sat, .sun]
        
        if selectedDays.intersection(weekdays) == weekdays {
            selectedDays.insert(.weekday)
        } else {
            selectedDays.remove(.weekday)
        }
        
        if selectedDays.intersection(weekend) == weekend {
            selectedDays.insert(.weekend)
        } else {
            selectedDays.remove(.weekend)
        }
        
        if selectedDays.intersection(DayType.allCases) == Set(DayType.allCases.prefix(7)) {
            selectedDays.insert(.everyday)
        } else {
            selectedDays.remove(.everyday)
        }
        
    }
}





struct DayButton: View {
    let day: DaySettingView.DayType
    let isSelected: Bool
    let action: () -> Void
    let buttonWidth: Int = 72
    
    var body: some View {
        Button(action: action) {
            
            if day == .everyday || day == .weekday || day == .weekend {
                Text(day.rawValue)
                    .font(.pretendard(size: 16, family: .medium))
                    .frame(width: 72,height: 45)
                    .background(isSelected ? Color.blue: Color.gray.opacity(0.2))
                    .foregroundStyle(isSelected ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
            } else {
                
                Text(day.rawValue)
                    .font(.pretendard(size: 16, family: .medium))
                    .frame(width: 45,height: 45)
                    .background(isSelected ? Color.blue: Color.gray.opacity(0.2))
                    .foregroundStyle(isSelected ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            
        }
        .buttonStyle(.borderless)
        
    }
}

struct RepeatSettingView: View {
    @Binding var selectedRepeat: RepeatedType
    
    enum RepeatedType: String, CaseIterable {
        case none = "없음"
        case everyWeek = "매주"
        case thisWeek = "이번주"
        case everyMonty = "매월"
    }
    
    var body: some View {
        HStack {
            ForEach(RepeatedType.allCases,id: \.self) { type in
                RepeatedButton(type: type,
                               isSelected: selectedRepeat == type,
                               action: {
                                   selectedRepeat = type
                            }
                        )
                    }
                }
            }
        }

struct RepeatedButton: View {
    let type: RepeatSettingView.RepeatedType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.pretendard(size: 16, family: .medium))
                .frame(width: 72,height: 45)
                .background(isSelected ? Color.blue: Color.gray.opacity(0.2))
                .foregroundStyle(isSelected ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
        }
        .buttonStyle(.borderless)
    }
}


