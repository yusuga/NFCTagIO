//
//  RightButtonHeader.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import SwiftUI

struct RightButtonHeader: View {

  let title: String
  let buttonTitle: String
  let buttonAction: () -> Void

  var body: some View {
    HStack {
      Text(title)

      Spacer()

      Button(buttonTitle, action: buttonAction)
        .font(.caption)
    }
  }
}

#Preview {
  List {
    Section {
      Text("Text")
    } header: {
      RightButtonHeader(title: "Title", buttonTitle: "Button", buttonAction: {})
    }
  }
}
