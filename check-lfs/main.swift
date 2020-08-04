//
//  main.swift
//  check-lfs
//
//  Created by 王 巍 on 2020/08/03.
//  Copyright © 2020 OneV's Den. All rights reserved.
//

import Foundation
import ArgumentParser
import Rainbow

struct CheckLFS: ParsableCommand {

    @Argument(help: "The branch to check.")
    var currentBranch = "HEAD"

    @Argument(help: "The base branch name.")
    var baseBranch = "master"

    mutating func run() throws {
        var parser = GitLogParser(base: baseBranch, branch: currentBranch)
        let binaries = try parser.allBinaries()
        if !binaries.isEmpty {
            print("Found binary files in the branch/commits:".red)
            for binary in binaries {
                print(binary.red)
            }
            Self.exit(withError: ExitCode(127))
        }
    }
}

CheckLFS.main()

