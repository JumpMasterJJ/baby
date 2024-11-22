pub fn Joinable::tree_below_key[T, E : Compare](
  scheme : Joinable[T, E],
  t : T,
  x : E
) -> Bool {
  let view = scheme.view
  match view(t) {
    Leaf => true
    Node(_, v, r) => E::compare(max_elt_1(scheme, v, r), x) < 0
  }
}

pub fn Joinable::key_below_tree[T, E : Compare](
  scheme : Joinable[T, E],
  x : E,
  t : T
) -> Bool {
  let view = scheme.view
  match view(t) {
    Leaf => true
    Node(l, v, _) => E::compare(x, min_elt_1(scheme, v, l)) < 0
  }
}

pub fn Joinable::lax_join[T, E : Compare](
  scheme : Joinable[T, E],
  l : T,
  v : E,
  r : T
) -> T {
  let join = scheme.join
  if tree_below_key(scheme, l, v) && key_below_tree(scheme, v, r) {
    join(l, v, r)
  } else {
    // TODO: error ?
    union(scheme, l, add(scheme, v, r))
  }
}

// TODO: what's type of return value
pub fn Joinable::map[T, E : Compare](
  scheme : Joinable[T, E],
  f : (E) -> E,
  t : T
) -> T {
  let view = scheme.view
  let leaf = scheme.leaf
  match view(t) {
    Leaf => leaf()
    Node(l, v, r) => {
      // Enforce leaf-to-right evaluation order
      let l_ = map(scheme, f, l)
      let v_ = f(v)
      let r_ = map(scheme, f, r)
      if physical_equal(l, l_) && physical_equal(v, v_) && physical_equal(r, r_) {
        t
      } else {
        lax_join(scheme, l_, v_, r_)
      }
    }
  }
}

pub fn Joinable::lax_join2[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T! {
  let view = scheme.view
  match (view(t1), view(t2)) {
    (Leaf, _) => t2
    (_, Leaf) => t1
    (_, _) =>
      if E::compare(max_elt!(scheme, t1), min_elt!(scheme, t2)) < 0 {
        join2(scheme, t1, t2)
      } else {
        union(scheme, t1, t2)
      }
  }
}

pub fn Joinable::filter_map[T, E : Compare](
  scheme : Joinable[T, E],
  f : (E) -> E?,
  t : T
) -> T! {
  let view = scheme.view
  let leaf = scheme.leaf
  match view(t) {
    Leaf => leaf()
    Node(l, v, r) => {
      // Enforce left-to-right evaluation order
      let l_ = filter_map!(scheme, f, l)
      let v_ = f(v)
      let r_ = filter_map!(scheme, f, l)
      match v_ {
        Some(v_) =>
          if Joinable::compare(scheme, l, l_) == 0 &&
            v == v_ &&
            Joinable::compare(scheme, r, r_) == 0 {
            t
          } else {
            lax_join(scheme, l_, v_, r_)
          }
        None => lax_join2!(scheme, l_, r_)
      }
    }
  }
}
