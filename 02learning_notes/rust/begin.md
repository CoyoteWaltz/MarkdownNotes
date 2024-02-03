# Learn Rust

> learning material
>
> [learn-rust-101](https://github.com/plabayo/learn-rust-101#1-learn-rust): Roadmap of Being A Rustacean
>
> Write a cli to encode protobuf in Rust

## Installation

Through `rustup`

```bash
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

Check rust compiler `rustc`

```bash
rustc --version
```

update `rustup update`

uninstall `rustup self uninstall`

### hello rust

```rust filename="main.rs"
fn main() {
	println!("Helldddo, world!");
}
```

build: `rustc main.rs`

exec: `./main`

### Cargo

```bash
cargo --version
```

Creating a project with cargo

```bash
cargo new hello_cargo
```

Default with git `--vcs=git`(VCS version control system)

#### Cargo.toml

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

#### Build and run

```bash
cargo build
./target/debug/hello_cargo
```

or just run code

```bash
cargo run
```

Instead of saving the result of the build in the same directory as our code, Cargo stores it in the *target/debug* directory.

#### build release

`cargo build --release` to compile it with optimizations.

create executable in `target/release`. Run your program faster but more time on compilation.

#### Cargo as Convention

Officially Nice.

Cargo knows semantic version very well.

`cargo update` will only check the available versions about the semantic version.

`cargo doc --open` command will build documentation provided by all your dependencies locally and open it in your browser.

## Basic

### Variables and Mutability

**by default, variables are immutable.**

once a value is bound to a name, you can’t change that value.

Why immutable? Hard to track if a part of code change another's value.

```rust
fn main() {
    let x = 5;
    println!("The value of x is: {x}");
    x = 6;  // error
    println!("The value of x is: {x}");
}
```

Mutability can be very useful. Use `mut` keyword.

```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {x}");
    x = 6;  // ok
    println!("The value of x is: {x}");
}
```

#### Constants

`const` keyword (`mut` is not allowed)

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Constants may be set only to a constant expression, **not the result of a value that could only be computed at runtime**.

Naming convention for constants is ALL_UPPERCASE_WITH_UNDERSCORES.

#### Shadowing

U can declare a new variable with the same name as a previous variable.

```rust
fn main() {
	let x = 5;
	let x = x + 1;
	{
		let x = x * 2;
		println!("The value of x in the inner scope is: {x}"); // 12
	}
	println!("The value of x is: {x}"); // 6
}
```

Shadowing is different from marking a variable as `mut`.

By using `let`, **we can perform a few transformations** on a value but have the variable be immutable after those transformations have been completed.

We can change the type but reuse the same name.

```rust
    let spaces = "   ";
    let spaces = spaces.len();

```

We dont have to use different name such as `spaces_num`.

### Data Types

scalar and compound.

```rust
let guess: u32 = "42".parse().expect("Not a number!");
```

If no `:u32` which specify the type, Rust will display err because compiler needs more information about the type.

#### Scaler

**Integer Types**

i8~i128(or `u`)

Each signed variant can store numbers from .., where *n* is the number of bits that variant uses. So an `i8` can store numbers from -(27) to 27 - 1, which equals -128 to 127.

arch? `isize` or `usize` depend on the architecture of the computer(64 / 32 bit architecture)

We can use `_` to make number easier to read `1_000`

integer types default to `i32`.

**Integer Overflow**

- In debug mode:
  - Rust will check integer overflow and _panic_
- In release mode(with `--release`)
  - Rust will not include check and panic, but perform _two’s complement wrapping_.
    - Greater than maximum → wrap around to the minimum(for `u8`, 256 → 0, 257 → 1)
    - To explicitly handle the possibility of overflow
      - all modes with the `wrapping_*` methods

**floating-point**

`f32` and `f64`(default)

**Boolean**

Booleans are one byte in size.

**Character**

```rust
let c = 'z';
let z: char = 'ℤ'; // with explicit type annotation
let heart_eyed_cat = '😻';
```

Use single quotes! 4 bytes in size.

#### Compound Types

**Tuple Type**

With a fixed length.

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
let (x, y, z) = tup;
println!("Test Tuple {}", tup.0);
println!("Test Tuple x {}, y {}, x {}", x, y, z);
```

**Array**

Fixed length. Same type of the elements. Allocate data on the stack.

Like Array in c/c++? **Vector** type allows to grow and shrink in size.

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Define a repeated array.

```rust
let five_three = [3; 5]; // [3, 3, 3, 3, 3]
```

Rust will panic if the index is out of the range. And that is _memory safe_ in Rust. In many low-level languages, this kind of check is not done, and when you provide an incorrect index, **invalid memory can be accessed**.

### Functions

_snake case as the conventional style_: `name_convention`

The order of defining functions doesn't matter as long as it is called with the scope.

**Statements & Expressions is distinct in Rust!**

- **Statements** are instructions that perform some action and do not return a value.(Do sth)
  - which means assignment doesn't return a value. `let x = (let y = 6);` will fail to compile
- **Expressions** evaluate to a resultant value.
  - a function call is an expression

```rust
let y = {
	let x = 3;
	x + 1
};
// if you add a semicolon to the end of an expression, you turn it into a statement, and it will then not return a value.
```

Functions return type must be declare by `->`. Return value can be the final **expression** of the function or use `return`.

```rust
fn five() -> i32 {
	5   // no `;` so it's an expression
}
```

BTW, Rust compiler is friendly haha.

### Control Flow

#### `if` expression

There is no implicit type conversion in Rust!( in javascript if (1) or if (!'')).

if is an expression, so it can be used to assign value. (Each block should be the same type. Variables must have a single type.)

```rust
let real_time = if time > 1 { 10 } else { 0 };
```

#### loops

Rust has three kinds of loops: `loop`, `while`, and `for`.

**loop**

```rust
fn loop_fn(time: i32) {
    let mut i = 0;
    loop {
        if i > time {
            break;  // jump out of loop until u tell
        }
        i += 1;
      	// continue;
        println!("in the loop, {}", i);
    }
}
```

loop with return value

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {result}");  // 20
}
```

**Conditional Loops with `while`**

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{number}!");

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

**for in collect**

```rust

fn buy_four() {
    let items = [1, 2, 3, 4];
    for item in items {
        println!("buy {}", item);
    }
}
```

use a `Range`, provided by the standard library, which generates all numbers in sequence starting from one number and ending before another number.

```rust
fn buy_four() {
    let items = [1, 2, 3, 4];
    for item in items {
        for i in (1..20).rev() {  // prettier simple
            println!("buy {} with {}", item, i);
        }
    }
}
```

## Ownership

> *Ownership* is a set of rules that govern how a Rust program **manages memory**.

Programming languages have ways to manage memory on users' computers like GC(JS, Go, ...) or explicitly allocate memory(C, C++).

Rust: memory is managed through _a system of ownership_ with a set of rules that the compiler checks.

- _ownership_ features wont slow down the speedy
- as long as rules are valid, the complier will work

Recap: Stacks and Heap

- Stack: store data with known, fixed size in the order it gets them and removes the values in the opposite order
- Heap: less organized. Require a certain amount of space and get a pointer to the slot of the space.(_Think of being seated at a restaurant. When you enter, you state the number of people in your group, and the host finds an empty table that fits everyone and leads you there. If someone in your group comes late, they can ask where you’ve been seated to find you._)

Pushing to stack is faster than allocating on the heap. Get the data from heap is slower than accessing stack data.

#### Ownership rules

- Each value in Rust has an *owner*.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.

#### String Type

More complex type. Data is store on the heap. `String` manages data allocated on the heap and as such is able to store an amount of text that is unknown to us at compile time.

```rust
let mut s = String::from("yes ok"); // instance from a string literal

s.push_str("! no"); // append a literal string

println!("{}", s);
```

String can be mutated but literals cannot.

#### Memory and allocation

The memory is **automatically** returned once the variable that owns it goes out of scope.

```rust
    {
        let s = String::from("hello"); // s is valid from this point forward
        // do stuff with s
    }                                  // this scope is now over, and s is no longer valid
```

When a variable goes out of a scope, rust will call `drop` function.

> Note: In C++, this pattern of deallocating resources at the end of an item’s lifetime is sometimes called *Resource Acquisition Is Initialization (RAII)*. The `drop` function in Rust will be familiar to you if you’ve used RAII patterns.
>
> Like Destructor in C++!

Data Move:

```rust
let s1 = String::from("hello");
let s2 = s1;
```

String contains a length, a pointer to the string data, a capacity. When assign `s1` to `s2`, wont copy the pointer data!(Not really a **Shallow copy**, but **move**)

Rust considers `s1` as no longer valid. Rust wont free `s1` when going out of scope. Only `s2` is valid and will be freed after scope.

```rust
let s1 = String::from("hello");
let s2 = s1;

println!("{}, world!", s1); // error!
```

Rust will never automatically create “deep” copies of your data.

Clone:(expensive)

```rust
let s2 = s1.clone();  // deep copy with heap data
```

Stack-only data copy:

```rust
let x = 4;
let y = x; // simply data copy
```

Copy:

If a type implements the `Copy` trait(covered later), variables that use it do not move, but rather are trivially copied, making them still valid after assignment to another variable.

_Rust won’t let us annotate a type with `Copy` if the type, or any of its parts, has implemented the `Drop` trait._ (`Drop` trait is like `destructor` or `defer` in Go or `Symbol.dispose` in JS?)

Summary of `Copy`: if a type implement `Copy` trait, the value can be simply assign to another variable as another copied value.

- All the integer types, such as `u32`.
- The Boolean type, `bool`, with values `true` and `false`.
- All the floating-point types, such as `f64`.
- The character type, `char`.
- Tuples, if they only contain types that also implement `Copy`. For example, `(i32, i32)` implements `Copy`, but `(i32, String)` does not.

Ownership and Functions:

Passing variable to functions is just like assignment(move or copy).

```rust
fn test() {
	let s1 = String::from("hello");
	take_string_ownership(s1);
	let s2 = s1.clone(); // error!
	println!("{} {}, world!", s1, s2);
}
fn take_string_ownership(sx: String) {
	println!("{}", sx);
	// sx leaves and drop!
}
```

Return values and scope:

```rust
fn test() {
	let s1 = give_string_ownership();
	let s1 = take_string_ownership(s1);
	let s2 = s1.clone();
	println!("{} {}, world!", s1, s2);
}

fn take_string_ownership(sx: String) -> String {
	println!("{}", sx);
	sx   // give back
}

fn give_string_ownership() -> String {
	let s = String::from("yes ok");
	s
}

```

A bit tedious...

```rust
fn main() {
    let s1 = String::from("hello");

    let (s2, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s2, len);
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len(); // len() returns the length of a String

    (s, length)
}
```

Luckily for us, Rust has a feature for using a value without transferring ownership, called *references*.

Introduce _references_

_Simply speaking, when a complex(type) variable is assigned to another variable, the owner is transferred!_

## Reference and Borrowing

Unlike a pointer, a reference is guaranteed to point to **a valid value** of a particular type for the life of that reference.

Example of using reference instead of taking the ownership of the variable:

```rust
fn main() {
	let s1 = String::from("hello");
	let len = calculate_length(&s1);
	println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
	s.len()
}
```

The `&s1` syntax lets us create a reference that *refers* to the value of `s1` but does not own it. It's called _reference borrowing_.

Just as variables are **immutable by default**, so are references. **We’re not allowed to modify something we have a reference to**.

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

Mutable references have one big restriction: **if you have a mutable reference to a value, you can have no other references to that value.**

```rust
    let mut s = String::from("hello");

    let r1 = &mut s;
    let r2 = &mut s;

    println!("{}, {}", r1, r2);  // failed
```

The benefit of having this restriction is that Rust can prevent **data races** at compile time. A _data race_ is similar to a race condition and happens when these three behaviors occur:

- Two or more pointers access the same data at the same time.
- At least one of the pointers is being used to write to the data.
- There’s no mechanism being used to synchronize access to the data.

```rust
    let mut s = String::from("hello");

    {
        let r1 = &mut s;
    } // r1 goes out of scope here, so we can make a new reference with no problems.

    let r2 = &mut s;
```

Remember not to use multiple reference on the same variable.

```rust
    let mut s = String::from("hello");

    let r1 = &s; // no problem
    let r2 = &s; // no problem
    println!("{} and {}", r1, r2);
    // variables r1 and r2 will not be used after this point

    let r3 = &mut s; // no problem
    println!("{}", r3);
```

Explaination: The scopes of the immutable references `r1` and `r2` end after the `println!` where they are last used, which is before the mutable reference `r3` is created. These scopes don’t overlap, so this code is allowed: the compiler can tell that the reference is no longer being used at a point before the end of the scope.

**Dangling References**

In Rust, by contrast, the compiler guarantees that references will never be dangling references

```rust
fn dangle() -> &String { // dangle returns a reference to a String

    let s = String::from("hello"); // s is a new String

    &s // we return a reference to the String, s
} // Here, s goes out of scope, and is dropped. Its memory goes away.
  // Danger!

// return s is valid(give new ownership)
```

Recap! Rules of reference:

- At any given time, you can have _either_ one mutable reference _or_ any number of immutable references.
- References must always be valid.

## The Slice Type

> _Slices_ let you reference a contiguous sequence of elements in a collection rather than the whole collection. A slice is a kind of reference, so it does not have ownership.
>
> **Slice is a kind of reference. It doesn't have ownership.**

### String Slices

```rust
let s = String::from("hello world");
let hello = &s[0..5];  // range syntax
let world = &s[6..];

println!("{}{}", hello, world);
```

Internally, the slice data structure stores the starting position and the length of the slice, which corresponds to `ending_index` minus `starting_index`.

You can drop the first and last index. `&s[..3]` `&s[3..]`

Drop both values `let slice = &s[..];`

Just like `string.slice()` in JavaScript! But a new reference!

Let's rewrite the `first_word` function:

```rust
fn new_first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[..i];
        }
    }
    return &s[..];
}
```

**Notice the type literal of String Slice is `&str`.**

#### String literals as slices

```rust
let s = "Hello, world!";  // type -> &str
```

#### String literals as paramters

A more experienced Rustacean would write the signature shown instead because it allows us to use the same function on both `&String` values and `&str` values. (later _deref coercions_)

```rust
fn first_word(s: &str) -> &str {

```

### Other Slices

```rust
    let a = [1, 2, 3, 4, 5];
    let slice = &a[1..3];
    assert_eq!(slice, &[2, 3]);
```

This slice has the type `&[i32]`

## Structs

Define a struct like a general template for the type

```rust
struct Foo {
    bar: i64,
    name: String,
    age: u64,
    is_odd: bool,
}
```

Create instance

```rust
    let foo = Foo {
        bar: 123,
        name: String::from("Yesok"),
        age: 3333,
        is_odd: false,
    };
```

Retrieve value from struct using dot notation(like javascript)

**Note that the entire instance must be mutable; Rust doesn’t allow us to mark only certain fields as mutable.**

Using struct update syntax to create instance from another instance. Just like `...` in JavaScript but the `..foo` must come last to specify.

```rust
    let foo2 = Foo {
        // name: String::from("foo2"),
      	age: 123,
        ..foo
    };
```

Note that the _struct update syntax_ is moving the data: the type doesnt implement `Copy` trait(`String`)

### Tuple structs

Tuple: no named associated with fields.

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);
}
```

### Unit-like struct

```rust
struct AlwaysEqual;

fn main() {
    let subject = AlwaysEqual;
}
```

Unit-like structs can be useful when you need to implement a **trait** on some type but don’t have any data that you want to store in the type itself.

### Ownership of Struct Data

Discuss later.
