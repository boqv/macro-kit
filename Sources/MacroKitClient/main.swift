import MacroKit

@Withable
struct Person {
    let firstname: String
    let lastname: String?
    let age: Int
}

let person = Person(firstname: "foo", lastname: "bar", age: 20)

let newPerson = person.with {
    $0.firstname = "new name"
    $0.lastname = nil
}

print(person)
print(newPerson)
