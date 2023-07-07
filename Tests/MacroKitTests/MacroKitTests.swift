import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

let testMacros: [String: Macro.Type] = [
    "Withable": WithMacro.self,
]

final class MacroKitTests: XCTestCase {
    func testWithMacro() {
        assertMacroExpansion(
            """
            @Withable
            struct Person {
                let firstname: String
                let lastname: String?
                let age: Int
            }
            """,
            expandedSource:
            """
            struct Person {
                let firstname: String
                let lastname: String?
                let age: Int
                public func with(configuration: (inout (firstname: String, lastname: String?, age: Int)) -> Void) -> Person {
                    var builder = (firstname: self.firstname, lastname: self.lastname, age: self.age)
                    configuration(&builder)
                    return Person(firstname: builder.firstname, lastname: builder.lastname, age: builder.age)
                }
            }
            """,
            macros: testMacros
        )
    }
}

