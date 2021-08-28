//
//  UserRow.swift
//  UserRow
//
//  Created by Djuro on 8/28/21.
//

import SwiftUI

struct UserRow: View {
    @State var user: User

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl))
                .frame(width: 44, height: 44)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))

            Text(user.login)
                .font(Font.system(size: 16).bold())

            Spacer()
        }
        .frame(height: 60)
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: User(id: 1, login: "djalfirevic", avatarUrl: "https://icon-library.com/images/user-icon-jpg/user-icon-jpg-2.jpg"))
    }
}
