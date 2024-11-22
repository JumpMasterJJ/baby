pub fn Joinable::cardinal_get[T, E](scheme: Joinable[T, E], t: T, i: Int) -> E {
  let view = scheme.view
  let cardinal = scheme.cardinal
  guard 0 <= i && i < cardinal(t)
  match view(t) {
    Leaf => panic()
    Node (l, v, r) => {
      let cl = cardinal(l)
      if i == cl {
        v
      } else if i < cl {
        cardinal_get(scheme, l, i)
      } else {
        cardinal_get(scheme, r, (i - (cl + 1)))
      }
    }
  }
}

pub fn Joinable::get[T, E](scheme: Joinable[T, E], t: T, i: Int) -> E! {
  let view = scheme.view
  let cardinal = scheme.cardinal
  let constant_time_cardinl = scheme.constant_time_cardinal
  if constant_time_cardinal {
    if 0 <= i && i < cardinal(t) {
      cardinal_get(scheme, t, i)
    } else {
      raise Out_of_boundary ("get: index %d is out of expected range [0, \{cardinal(t)})")
    }
  } else {
    raise Not_available
  }
}

pub fn Joinable::index_from_i[T, E: Compare](scheme: Joinable[T, E], i: Int, x: E, t: T) -> Int!Not_found {
  let view = scheme.view
  let cardinal = scheme.cardinal
  match view(t) {
    Leaf => raise Not_found
    Node (l, v ,r) => {
      let c= E::compare(x, v)
      if c < 0 {
        index_from_i!(scheme, i, x, l)
      } else {
        let i  = i + cardinal(l)
        if c == 0 { i } else { index_from_i!(scheme, i + 1, x, r) }
      }
    }
  }
}

pub fn Joinable::index[T, E: Compare](scheme: Joinable[T, E], x: E, t: T) -> Int! {
  let constant_time_cardinal = scheme.constant_time_cardinal
  if constant_time_cardinal {
    index_from_i!(scheme, 0, x, t)
  } else {
    raise Not_available
  }
}

pub fn Joinable::cardinal_cut[T, E: Compare](scheme: Joinable[T, E], t: T, i: Int) -> (T, T)! {
  let view = scheme.view
  let leaf= scheme.leaf
  let join = scheme.join
  let cardinal = scheme.cardinal
  guard (0 <= i && i <= cardinal(t))
  if i == 0 {
    (leaf(), t)
  } else if i == cardinal(t) {
    (t, leaf())
  } else {
    guard let Node (l, v, r) = view(t)
    let cl = cardinal(t)
    if i <= cl {
      let (ll, lr) = cardinal_cut!(scheme, r, i - (cl + 1))
      guard Joinable::compare(scheme, lr, l) != 0
      (ll, join(lr, v, r))
    } else {
      let (rl, rr) = cardinal_cut!(scheme, r, i - (cl + 1))
      guard Joinable::compare(scheme, rl, r) != 0
      (join(l, v, rl), rr)
    }
  }
}

pub fn Joinable::cut[T, E: Compare](scheme: Joinable[T, E], t: T, i: Int) -> (T, T)! {
  let cardinal = scheme.cardinal
  let constant_time_cardinal = scheme.constant_time_cardinal
  if constant_time_cardinal {
    if 0 <= i && i <= cardinal(t) {
      cardinal_cut!(scheme, t, i)
    } else {
      raise Out_of_boundary ("cut: index %d is out of expected range [0, \{cardinal(t)})")
    }
  } else {
    raise Not_available
  }
}

pub fn Joinable::cardinal_cut_and_get[T, E](scheme: Joinable[T, E], t: T, i: Int) -> (T, E, T)! {
  let view = scheme.view
  let join  = scheme.join
  let cardinal = scheme.cardinal
  guard 0 <= i && i < cardinal(t)
  guard let Node (l, v, r) = view(t)
  let cl = cardinal(l)
  if i == cl {
    (l, v, r)
  } else if i < cl {
    let (ll, lv, lr) = cardinal_cut_and_get!(scheme, l, i)
    (ll, lv, join(lr, v, r))
  } else {
    let (rl, rv, rr) = cardinal_cut_and_get!(scheme, r, i - (cl + 1))
    (join(l, v, rl), rv , rr)
  }
}

pub fn Joinable::cut_and_get[T, E](scheme: Joinable[T, E], t: T, i: Int) -> (T, E, T)! {
  let cardinal = scheme.cardinal
  let constant_time_cardinal = scheme.constant_time_cardinal
  if constant_time_cardinal {
    if 0 <= i && i < cardinal(t) {
      cardinal_cut_and_get!(scheme, t, i)
    } else {
      raise Out_of_boundary ("cut: index %d is out of expected range [0, \{cardinal(t)})")
    }
  } else {
    raise Not_available
  }
}