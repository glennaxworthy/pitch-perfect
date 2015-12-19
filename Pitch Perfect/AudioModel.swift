//
//  Model.swift
//  Pitch Perfect
//
//  Created by Glenn Axworthy on 11/28/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

class AudioModel {

    let fileName: String
    let fileURL: NSURL

    init(fileName: String, fileURL: NSURL) {
        self.fileName = fileName
        self.fileURL = fileURL
    }

    deinit {
        // delete model data if it exists
        try! NSFileManager().removeItemAtURL(fileURL)
    }
}
