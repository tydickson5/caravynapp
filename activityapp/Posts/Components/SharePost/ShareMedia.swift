//
//  ShareMedia.swift
//  caravyn
//
//  Created by Ty Dickson on 10/8/26.
//


import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers

struct ShareableVideo: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .mpeg4Movie) { video in
            SentTransferredFile(video.url)
        }
    }
}
