fn foreach_increasing_run_in_slice[A : Compare, B](
  yield_ : (B, Int, Int) -> B,
  accu : B,
  a : Array[A],
  i : Int,
  n : Int
) -> B {
  guard 0 <= i && i <= n && n <= Array::length(a)
  if i == n {
    // There are no more runs.
    accu
  } else {
    // A new run begins at index [i].
    let last = a[i]
    let j = i + 1
    scan(yield_, accu, a, i, last, j, n)
  }
}

fn scan[A : Compare, B](
  yield_ : (B, Int, Int) -> B,
  accu : B,
  a : Array[A],
  i : Int,
  last : A,
  j : Int,
  n : Int
) -> B {
  guard 0 <= i && i <= j && j <= n && n <= Array::length(a)
  if j == n {
    // The run [i, j] ends here, and the loop ends as well.
    yield_(accu, i, j)
  } else {
    let current = a[j]
    if A::compare(last, current) < 0 {
      // The current run continues
      let last = current
      let j = j + 1
      scan(yield_, accu, a, i, last, j, n)
    } else {
      // The run [i, j] ends here, and the loop continues.
      let accu = yield_(accu, i, j)
      let last = current
      let i = j
      let j = j + 1
      scan(yield_, accu, a, i, last, j, n)
    }
  }
}

fn compress[A : Compare](a : Array[A]) -> Int {
  a.dedup()
  a.length()
}

fn foreach_increasing_run[A : Compare, B](
  yield_ : (B, Int, Int) -> B,
  accu : B,
  a : Array[A]
) -> B {
  let i = 0
  let n = a.length()
  foreach_increasing_run_in_slice(yield_, accu, a, i, n)
}

fn increasing_runs[A : Compare](
  compare : (A, A) -> Int,
  a : Array[A]
) -> List[Run] {
  fn yield_(runs, i, j) {
    List::add(runs, (i, j))
  }

  foreach_increasing_run(yield_, List::Nil, a).rev()
}
