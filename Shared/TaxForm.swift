//
//  ContentView.swift
//  Shared
//
//  Created by yk on 2021/7/5.
//

import SwiftUI
import Combine

struct EasyPicker<T>: View where T: Hashable {
  var label: String
  var systemImage: String
  var range: Range<Int>
  var selection: Binding<T>

  var body: some View {
    Picker(
      selection: selection,
      label: Label(label, systemImage: systemImage)
    ) {
      ForEach(range, id: \.self) {
        Text("\($0)%").tag($0)
      }
    }.listRowSeparator(.automatic)
  }
}

extension NumberFormatter {
  static var currency: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }
}

struct TaxForm: View {
  enum TaxType: Int, CaseIterable {
    case salaries
    case labor
    case remuneration
    case royalties
  }
  @State var visibleSetting = false

  @AppStorage("taxtype") private var taxType: TaxType = .salaries
  @AppStorage("basesalaries") private var baseSalaries: String = ""
  @AppStorage("yanglao") private var yanglao: Int = 8
  @AppStorage("gongjijin") private var gongjijin: Int = 7
  @AppStorage("shiye") private var shiye: Int = 2
  @AppStorage("yiliao") private var yiliao: Int = 3


  var body: some View {
    NavigationView {
      Form {
        Section(
          header: Text("个税种类"),
          footer: Text("不同的种类会有不同的税率规则，默认采用工资")
        ) {
          Picker("税率分类", selection: $taxType) {
            ForEach(
              Array(zip(TaxType.allCases, ["工资酬金", "劳务报酬", "稿酬", "特许权使用费"])),
              id: \.0
            ) {
              Text($0.1).tag($0.0)
            }
          }
        }
        Section(header: Text("💰 基本工资")) {
          TextField(value: $baseSalaries, formatter: NumberFormatter.currency) {
            Label("每月工资", systemImage: "yensign.circle")
          }
          .keyboardType(.numberPad)
          .textContentType(.creditCardNumber)
          .onReceive(Just(baseSalaries)) { newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }

            if filtered != newValue {
              baseSalaries = filtered
            }
          }
        }

        Section(header: Text("五险一金")) {
          EasyPicker(
            label: "公积金",
            systemImage: "house",
            range: 0..<21,
            selection: $gongjijin
          )
          EasyPicker(
            label: "养老保险",
            systemImage: "tortoise",
            range: 0..<10,
            selection: $yanglao
          )
          EasyPicker(
            label: "医疗保险",
            systemImage: "cross.case",
            range: 0..<5,
            selection: $yiliao
          )
          EasyPicker(
            label: "失业保险",
            systemImage: "figure.walk",
            range: 0..<5,
            selection: $shiye
          )
//        另外一种样式
//          Stepper(value: $gongjijin, in: 0...12, step: 1) {
//            Text("💰 公积金: \(gongjijin)%")
//          }
        }

        Button(
          action: {},
          label: { Label("Confirm", systemImage: "banknote") }
        )
          .disabled(baseSalaries.isEmpty)
      }
      .sheet(isPresented: $visibleSetting) {
        TaxBaseSetting()
      }
      .navigationBarTitle("税率计算", displayMode: .inline)
      .navigationBarItems(trailing: Button(action: {
        visibleSetting.toggle()
      }) {
        Label("设置", systemImage: "gear")
      })
      .ignoresSafeArea(.keyboard)
    }
  }
}

extension TaxForm {

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TaxForm()
      TaxForm()
        .preferredColorScheme(.dark)
    }
  }
}
