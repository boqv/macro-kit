import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct WithMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            fatalError("can only be applied to structs")
        }

        let members = structDecl.memberBlock.members

        let variableDecl = members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }

        return [
            DeclSyntax(
                stringLiteral: with(
                    structName: structDecl.identifier.text,
                    names: variableDecl
                        .compactMap { $0.bindings.first?.pattern },
                    types: variableDecl
                        .compactMap { $0.bindings.first?.typeAnnotation}
                )
            )
        ]
    }
}

private func with(
    structName: String,
    names: [PatternSyntax],
    types: [TypeAnnotationSyntax]
) -> String {
    let configurationType = tupleDeclaration(names: names, types: types)
    let builder = tupleImplementation(structName: structName, names: names)
    return """
    public func with(configuration: (inout (\(configurationType))) -> Void) -> \(structName) {
        var builder = (\(builder))
        configuration(&builder)
        return \(structName)(\(build(structName: structName, names: names)))
    }
    """
}

private func tupleDeclaration(
    names: [PatternSyntax],
    types: [TypeAnnotationSyntax]
) -> String {
    zip(names, types).map { name, type in
        "\(name): \(type.type)"
    }
    .joined(separator: ", ")
}

private func tupleImplementation(
    structName: String,
    names: [PatternSyntax]
) -> String {
    names.map { name in
        "\(name): self.\(name)"
    }
    .joined(separator: ", ")
}

private func build(
    structName: String,
    names: [PatternSyntax]
) -> String {
    names.map { name in
        "\(name): builder.\(name)"
    }
    .joined(separator: ", ")
}

@main
struct WithPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        WithMacro.self,
    ]
}
