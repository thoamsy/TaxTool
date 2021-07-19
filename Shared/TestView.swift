//
//  TestView.swift
//  TaxTool
//
//  Created by yk on 2021/7/6.
//

import SwiftUI

struct TestView: View {
  @State private var price = 99

  var body: some View {
    TextField(
      "type something...",
      value: $price,
      formatter: NumberFormatter.currency
    )

  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestView()
  }
}
