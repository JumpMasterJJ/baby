pub fn Joinable::elements[T, E](scheme : Joinable[T, E], t : T) -> List[E] {
  let view = scheme.view
  fn aux(t, k) {
    match view(t) {
      Leaf => k
      Node(l, v, r) => aux(l, List::add(aux(r, k), v))
    }
  }

  aux(t, List::Nil)
}

pub fn Joinable::to_list[T, E](scheme : Joinable[T, E], t : T) -> List[E] {
  Joinable::elements(scheme, t)
}

// TODO:
// fn to_seq
// fn to_seq_from
// fn to_rev_seq
// fn add_seq

pub fn Joinable::to_array_slice[T, E](
  scheme : Joinable[T, E],
  t : T,
  a : Array[E],
  i : Int
) -> Int {
  let cardinal = scheme.cardinal
  let view = scheme.view
  guard 0 <= i && i + cardinal(t) <= Array::length(a)
  match view(t) {
    Leaf => i
    Node(l, v, r) => {
      let i = to_array_slice(scheme, l, a, i)
      a[i] = v
      let i = i + 1
      to_array_slice(scheme, r, a, i)
    }
  }
}

pub fn Joinable::to_array[T, E](scheme : Joinable[T, E], t : T) -> Array[E] {
  let view = scheme.view
  let cardinal = scheme.cardinal
  match view(t) {
    Leaf => []
    Node(_, dummy, _) => {
      let n = cardinal(t)
      let a = Array::make(n, dummy)
      let j = to_array_slice(scheme, t, a, 0)
      guard n == j
      a
    }
  }
}

pub fn Joinable::of_sorted_unique_array_slice[T, E](
  scheme : Joinable[T, E],
  a : Array[E],
  i : Int,
  j : Int
) -> T {
  let singleton = scheme.singleton
  let doubleton = scheme.doubleton
  let tripleton = scheme.tripleton
  let join_weight_balanced = scheme.join_weight_balanced
  guard 0 <= i && i <= j && j <= Array::length(a)
  let n = j - i
  match n {
    0 => Joinable::empty(scheme)
    1 => singleton(a[i])
    2 => doubleton(a[i], a[i + 1])
    3 => tripleton(a[i], a[i + 1], a[i + 2])
    _ => {
      let k = i + n / 2
      let l = of_sorted_unique_array_slice(scheme, a, i, k)
      let v = a[k]
      let r = of_sorted_unique_array_slice(scheme, a, k + 1, j)
      join_weight_balanced(l, v, r)
    }
  }
}

pub fn Joinable::of_array[T, E : Compare](
  scheme : Joinable[T, E],
  a : Array[E]
) -> T {
  fn yield(accu, i, j) {
    Joinable::union(scheme, accu, of_sorted_unique_array_slice(scheme, a, i, j))
  }

  foreach_increasing_run(E::compare, yield, Joinable::empty(scheme), a)
}

pub fn Joinable::of_list[T, E : Compare](
  scheme : Joinable[T, E],
  xs : List[E]
) -> T {
  fn of_array(xs) {
    Joinable::of_array(scheme, xs)
  }

  xs |> List::to_array |> of_array
}

// TODO: Enum module
