import Logging
import Foundation

public protocol Loggable {
    func log(
        _ message: String,
        file: String,
        function: String,
        line: UInt
    )
}

extension Loggable {
    var logger: Logger {
        Logger(label: "vitor.varela.RecipeApp")
    }
    
    public func log(
        _ message: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        let logMessage = Logger.Message(stringLiteral: message)
        logger.info(logMessage, file: file, function: function, line: line)
    }
    
}
