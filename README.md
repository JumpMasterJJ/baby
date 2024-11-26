# baby
`baby` is a third-party library that uses moonbit to rewrite the ordered set based on the binary balanced tree, mainly referring to [`fpottier/baby`](https://github.com/fpottier/baby)

Currently, the height balance strategy and weight balance strategy are supported by default, and users are allowed to customize the balance strategy.

## Installation and Usage
To use this library, you should add a dependency on it by running the command line with [`moon`](https://moonbitlang.github.io/moon/zh/):
```shell
moon add jump/baby
```

## Advanced Uasge
If you need a custom balancing strategy, please implement the function: `scheme[E : Compare]() -> @base.Joinable[Tree[E], E]`.

And run `pre-build` to generate set/map operations based on your balancing strategy. For more details, please refer to implementations of `src/height` and `src/weight`.