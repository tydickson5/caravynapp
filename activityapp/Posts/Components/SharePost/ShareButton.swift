//
//  ShareButton.swift
//  caravyn
//
//  Created by Ty Dickson on 10/8/26.
//


//  ShareButton.swift
import SwiftUI

struct ShareButton: View {
    let image: UIImage?
    let videoURL: URL?
    let thumbnail: UIImage?

    init(image: UIImage? = nil, videoURL: URL? = nil, thumbnail: UIImage? = nil) {
        self.image = image
        self.videoURL = videoURL
        self.thumbnail = thumbnail
    }

    var body: some View {
        if let videoURL {
            ShareLink(
                item: ShareableVideo(url: videoURL),
                preview: SharePreview("Caravyn Video", image: videoPreviewImage)
            ) {
                shareLabel
            }
        } else if let image {
            ShareLink(
                item: Image(uiImage: image),
                preview: SharePreview("Caravyn Photo", image: Image(uiImage: image))
            ) {
                shareLabel
            }
        }
    }

    private var videoPreviewImage: Image {
        if let thumbnail { Image(uiImage: thumbnail) }
        else { Image(systemName: "video") }
    }

    private var shareLabel: some View {
        Image(systemName: "arrowshape.turn.up.right")
    }
}
