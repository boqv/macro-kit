/// A macro that allows structs to be copied with
/// modified properties
///
///     @Withable
///     struct Person {
///         let name: String
///         let age: Int
///     }
///
///     let person = Person(name: "foo", age: 20)
///     let otherPerson = person.with { $0.age = 25 }
///
/// produces a new struct with name "foo" and age 25.
@attached(member, names: named(with))
public macro Withable() = #externalMacro(module: "MacroKitMacros", type: "WithMacro")
