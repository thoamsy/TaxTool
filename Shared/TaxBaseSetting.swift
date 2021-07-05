//
//  TaxBaseSetting.swift
//  TaxTool
//
//  Created by yk on 2021/7/6.
//

import SwiftUI

struct TaxBaseSetting: View {
  @AppStorage("taxFreePoint") var taxFreePoint = "5000"
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      HStack(alignment: .center) {
        Spacer()
        Button("Dismiss", action: dismiss.callAsFunction)
      }.padding()
      Form {
        Section(header: Text("起征点")) {
          TextField("", text: $taxFreePoint)
            .textContentType(.creditCardNumber)
        }
      }
    }
  }
}

struct TaxBaseSetting_Previews: PreviewProvider {
  static var previews: some View {
    TaxBaseSetting()
      .preferredColorScheme(.dark)
  }
}
