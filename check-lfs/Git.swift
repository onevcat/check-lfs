//
//  Git.swift
//  check-lfs
//
//  Created by 王 巍 on 2020/08/03.
//  Copyright © 2020 OneV's Den. All rights reserved.
//

import Foundation
import SwiftExec

struct Git {
    static var version: String {
        var result: ExecResult
        do {
            result = try execBash("git --version")
        } catch {
            let error = error as! ExecError
            result = error.execResult
        }
        return result.stdout!
    }

    static func log(baseBranch: String, currentBranch: String) throws -> String? {

        let command =
        """
        git log --numstat --no-renames --diff-filter=d --format=format:"%h %s" \(baseBranch)..\(currentBranch)
        """
        return try execBash(command).stdout
    }
}

struct GitLogParser {
    let base: String
    let branch: String

    init(base: String, branch: String) {
        self.base = base
        self.branch = branch
    }

    private var cachedLogs: [GitLog]? = nil

    static func process(commitLog: String) -> GitLog? {
        let lines = commitLog
            .split(separator: "\n")
            .filter { !$0.isEmpty }
        guard lines.count > 1 else { return nil }

        let logLine = String(lines.first!)
        guard let splitIndex = logLine.firstIndex(of: " ") else { return nil }

        let hash = logLine[logLine.startIndex ..< splitIndex]
        let message = logLine[splitIndex..<logLine.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)

        let binaries = lines
            .dropFirst()
            .filter { $0.starts(with: "-\t-\t") }
            .map { $0.components(separatedBy: "-\t-\t") }
            .filter { $0.count > 1 }
            .map { $0[1] }

        return GitLog(hash: String(hash), message: message, binaries: binaries)
    }

    mutating func allBinaries() throws -> [String] {
        let logs = try unifyLogs()
        return logs.reduce([]) { result, log in
            let binaries = log.binaries
            return result + binaries
        }
    }

    mutating func unifyLogs() throws -> [GitLog] {
        if let cachedLogs = cachedLogs {
            return cachedLogs
        }

        guard let plainLogs = try Git.log(baseBranch: base, currentBranch: branch) else {
            cachedLogs = []
            return []
        }

        let logs = plainLogs
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n\n")
            .filter { !$0.isEmpty }
            .compactMap(GitLogParser.process)
        cachedLogs = logs
        return logs
    }

}

struct GitLog {
    let hash: String
    let message: String?
    let binaries: [String]
}
