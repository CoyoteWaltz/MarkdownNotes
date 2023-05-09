# Learn Rust

> learning material
>
> [learn-rust-101](https://github.com/plabayo/learn-rust-101#1-learn-rust): Roadmap of Being A Rustacean
>
> Write a cli to encode protobuf in Rust

## installation

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
