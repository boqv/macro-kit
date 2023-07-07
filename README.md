## Usage

```
@Withable
struct Person {
    let firstname: String
    let lastname: String
    let age: Int?
}

let person = Person(firstname: "foo", lastname: "bar", age: 50)

let otherPerson = person.with {
    $0.firstname = "new"
    $0.age = nil
}

print(person)
print(otherPerson)

// Person(firstname: "foo", lastname: "bar", age: 50)
// Person(firstname: "new", lastname: "bar", age: nil)
```





