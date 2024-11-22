pub fn Joinable::remove_min_elt_1[T, E](
  scheme : Joinable[T, E],
  l : T,
  v : E,
  r : T
) -> T {
  let view = scheme.view
  let join_neighbors = scheme.join_neighbors
  match view(l) {
    Leaf => r
    Node(ll, lv, lr) => {
      let l = remove_min_elt_1(scheme, ll, lv, lr)
      join_neighbors(l, v, r)
    }
  }
}

pub fn Joinable::remove_min_elt[T, E](
  scheme : Joinable[T, E],
  t : T
) -> T!Not_found {
  let view = scheme.view
  match view(t) {
    Leaf => raise Not_found
    Node(l, v, r) => remove_min_elt_1(scheme, l, v, r)
  }
}

pub fn Joinable::remove_max_elt_1[T, E](
  scheme : Joinable[T, E],
  l : T,
  v : E,
  r : T
) -> T {
  let view = scheme.view
  let join_neighbors = scheme.join_neighbors
  match view(r) {
    Leaf => l
    Node(rl, rv, rr) => {
      let l = remove_max_elt_1(scheme, rl, rv, rr)
      join_neighbors(l, v, r)
    }
  }
}

pub fn Joinable::remove_max_elt[T, E](
  scheme : Joinable[T, E],
  t : T
) -> T!Not_found {
  let view = scheme.view
  match view(t) {
    Leaf => raise Not_found
    Node(l, v, r) => remove_max_elt_1(scheme, l, v, r)
  }
}

pub fn Joinable::join2_siblings[T, E](
  scheme : Joinable[T, E],
  l : T,
  r : T
) -> T {
  let view = scheme.view
  let join_neighbors = scheme.join_neighbors
  match (view(l), view(r)) {
    (_, Leaf) => l
    (Leaf, _) => r
    (_, Node(rl, rv, rr)) =>
      join_neighbors(
        l,
        min_elt_1(scheme, rv, rl),
        remove_min_elt_1(scheme, rl, rv, rr),
      )
  }
}

///| This is removal in the style of BFS, to be disabled
/// pub fn Joinable::remove[T, E : Compare](
///   scheme : Joinable[T, E],
///   x : E,
///   t : T
/// ) -> T {
///   let (l, _, r) = split(scheme, x, t)
///   join2(scheme, l, r)
/// }

///|
/// This is a less elegant but more efficient version of removal.
pub fn Joinable::remove[T, E : Compare](
  scheme : Joinable[T, E],
  x : E,
  t : T
) -> T {
  let view = scheme.view
  let join_neighbors = scheme.join_neighbors
  match view(t) {
    Leaf => scheme.empty()
    Node(l, v, r) => {
      let c = E::compare(x, v)
      if c == 0 {
        join2_siblings(scheme, l, r)
      } else if c < 0 {
        let l_ = remove(scheme, x, l)
        if physical_equal(l, l_) {
          t
        } else {
          join_neighbors(l_, v, r)
        }
      } else {
        let r_ = remove(scheme, x, r)
        if physical_equal(r, r_) {
          t
        } else {
          join_neighbors(l, v, r_)
        }
      }
    }
  }
}