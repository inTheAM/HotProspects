//
//  ReviewCodeThird.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/20/20.
//

import SwiftUI
import SamplePackage

struct ReviewCodeThird: View {
	let possibleNumbers	=	Array(1...60)
	var results:	String	{
		let selected 	=	possibleNumbers.random(7).sorted()
		return selected.map(String.init).joined(separator: ", ")
	}
    var body: some View {
        Text(results)
    }
}

struct ReviewCodeThird_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCodeThird()
    }
}
