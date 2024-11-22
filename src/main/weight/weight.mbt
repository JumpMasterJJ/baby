fn max(x : Int, y : Int) -> Int {
  if x <= y {
    y
  } else {
    x
  }
}

// fn height[E](t: Tree[E]) -> Int {
//   match t {
//     TLeaf => 0
//     TNode (~h, ..) => h
//   }
// }

fn weight[E](t : Tree[E]) -> Int {
  match t {
    TLeaf => 1
    TNode(~w, ..) => w
  }
}

fn view[E](t : Tree[E]) -> View[Tree[E], E] {
  match t {
    TLeaf => Leaf
    TNode(~l, ~v, ~r, ..) => Node(l, v, r)
  }
}

fn leaf[E]() -> Tree[E] {
  TLeaf
}

let constant_time_cardinal = true

fn cardinal[E](t : Tree[E]) -> Int {
  weight(t) - 1
}

let alpha = 29

fn not_left_heavy(wl : Int, wr : Int) -> Bool {
  alpha * wl <= (100 - alpha) * wr
}

fn left_heavy(wl : Int, wr : Int) -> Bool {
  not_left_heavy(wl, wr) |> not
}

fn not_right_heavy(wl : Int, wr : Int) -> Bool {
  not_left_heavy(wr, wl)
}

fn right_heavy(wl : Int, wr : Int) -> Bool {
  not_right_heavy(wl, wr) |> not
}

fn like_weights(wl : Int, wr : Int) -> Bool {
  not_left_heavy(wl, wr) && not_right_heavy(wl, wr)
}

fn siblings[E](l : Tree[E], r : Tree[E]) -> Bool {
  like_weights(weight(l), weight(r))
}

// fn quasi_siblings[E](l: Tree[E], r: Tree[E]) -> Bool {
//   Int::abs(height(l) - height(r)) <= 3
// }

fn check[E](t : Tree[E]) -> Unit {
  match t {
    TLeaf => ()
    TNode(~l, ~r, ~w, ..) => {
      check(l)
      check(r)
      guard w == max(weight(l), weight(r))
      guard siblings(l, r)

    }
  }
}

fn create2[E](w : Int, l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  guard siblings(l, r)
  guard w == weight(l) + weight(r)
  TNode(~l, ~v, ~r, ~w)
}

fn create[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  let w = weight(l) + weight(r)
  create2(w, l, v, r)
}

fn create1[E](wl : Int, l : Tree[E], v : E, wr : Int, r : Tree[E]) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  let w = wl + wr
  create2(w, l, v, r)
}

// fn join_siblings[E](l: Tree[E], v: E, r: Tree[E]) -> Tree[E] {
//   create(l, v ,r)
// }

fn singleton[E](x : E) -> Tree[E] {
  let w = 2
  create2(w, TLeaf, x, TLeaf)
}

fn doubleton[E : Compare](x : E, y : E) -> Tree[E] {
  guard E::compare(x, y) < 0
  let w = 3
  create2(w, TLeaf, x, singleton(y))
}

fn tripleton[E : Compare](x : E, y : E, z : E) -> Tree[E] {
  guard E::compare(x, y) < 0
  guard E::compare(y, z) < 0
  let w = 4
  create2(w, singleton(x), y, singleton(z))
}

fn seems_smaller[E](t1 : Tree[E], t2 : Tree[E]) -> Bool {
  match (t1, t2) {
    (TLeaf, TLeaf) => false
    (TLeaf, _) => true
    (_, TLeaf) => false
    (TNode(w=w1, ..), TNode(w=w2, ..)) => w1 < w2
  }
}

fn destruct[E](t : Tree[E]) -> (Tree[E], E, Tree[E]) {
  match t {
    // TODO: panic or assert or raise ?
    TLeaf => panic()
    TNode(~l, ~v, ~r, ..) => (l, v, r)
  }
}

fn destructw[E](w : Int, t : Tree[E]) -> (Int, Tree[E], E, Int, Tree[E]) {
  let (tl, tv, tr) = destruct(t)
  let wtl = weight(tl)
  let wtr = w - wtl
  guard wtr == weight(tr)
  (wtl, tl, tv, wtr, tr)
}

fn balance_right_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard right_heavy(wl, wr)
  let (wrl, rl, rv, wrr, rr) = destructw(wr, r)
  if like_weights(wl, wrl) && like_weights(wl + wrl, wrr) {
    // Rotate left
    let w = wl + wr
    create2(w, create1(wl, l, v, wrl, rl), rv, rr)
  } else {
    // Rotate left and right
    let (wrll, rll, rlv, wrlr, rlr) = destructw(wrl, rl)
    let w = wl + wr
    create2(
      w,
      create1(wl, l, v, wrll, rll),
      rlv,
      create1(wrlr, rlr, rv, wrr, rr),
    )
  }
}

fn balance_maybe_right_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard not_left_heavy(wl, wr)
  if not_right_heavy(wl, wr) {
    create1(wl, l, v, wr, r)
  } else {
    balance_right_heavy(wl, l, v, wr, r)
  }
}

fn balance_left_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard left_heavy(wl, wr)
  let (wll, ll, lv, wlr, lr) = destructw(wl, l)
  if like_weights(wlr, wr) && like_weights(wll, wlr + wr) {
    // Rotate right
    let w = wl + wr
    create2(w, ll, lv, create1(wlr, lr, v, wr, r))
  } else {
    // Rotate right and left
    let (wlrl, lrl, lrv, wlrr, lrr) = destructw(wlr, lr)
    let w = wl + wr
    create2(
      w,
      create1(wll, ll, lv, wlrl, lrl),
      lrv,
      create1(wlrr, lrr, v, wr, r),
    )
  }
}

fn balance_maybe_left_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard not_right_heavy(wl, wr)
  if not_left_heavy(wl, wr) {
    create1(wl, l, v, wr, r)
  } else {
    balance_left_heavy(wl, l, v, wr, r)
  }
}

fn join_maybe_left_heavy[E](
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wr == weight(r)
  let wl = weight(l)
  guard not_right_heavy(wl, wr)
  if not_left_heavy(wl, wr) {
    create1(wl, l, v, wr, r)
  } else {
    join_left_heavy(wl, l, v, wr, r)
  }
}

fn join_left_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard left_heavy(wl, wr)
  let (wll, ll, lv, wlr, lr) = destructw(wl, l)
  balance_maybe_right_heavy(
    wll,
    ll,
    lv,
    wlr + wr,
    join_maybe_left_heavy(lr, v, wr, r),
  )
}

fn join_maybe_right_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l)
  let wr = weight(r)
  guard not_left_heavy(wl, wr)
  if not_right_heavy(wl, wr) {
    create1(wl, l, v, wr, r)
  } else {
    join_right_heavy(wl, l, v, wr, r)
  }
}

fn join_right_heavy[E](
  wl : Int,
  l : Tree[E],
  v : E,
  wr : Int,
  r : Tree[E]
) -> Tree[E] {
  guard wl == weight(l) && wr == weight(r)
  guard right_heavy(wl, wr)
  let (wrl, rl, rv, wrr, rr) = destructw(wr, r)
  balance_maybe_left_heavy(
    wl + wrl,
    join_maybe_right_heavy(wl, l, v, rl),
    rv,
    wrr,
    rr,
  )
}

fn join[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  let wl = weight(l)
  let wr = weight(r)
  if not_left_heavy(wl, wr) {
    if not_right_heavy(wl, wr) {
      // Balanced
      create1(wl, l, v, wr, r)
    } else {
      // Right heavy
      join_right_heavy(wl, l, v, wr, r)
    }
  } else {
    // Left heavy
    join_left_heavy(wl, l, v, wr, r)
  }
}

fn join_neighbors[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  let wl = weight(l)
  let wr = weight(r)
  if not_left_heavy(wl, wr) {
    if not_right_heavy(wl, wr) {
      // Balanced
      create1(wl, l, v, wr, r)
    } else {
      // Right heavy
      balance_right_heavy(wl, l, v, wr, r)
    }
  } else {
    // Left heavy
    balance_left_heavy(wl, l, v, wr, r)
  }
}

// fn bal[E](l: Tree[E], v: E, r: Tree[E]) -> Tree[E] {
//   guard quasi_siblings(l, r)
//   let hl = height(l)
//   let hr = height(r)
//   if hl > hr + 2 {
//     let (ll, lv, lr) = destruct(l)
//     if height(ll) >= height(lr) {
//       create(ll, lv, create(lr, v, r))
//     } else {
//       let (lrl, lrv, lrr) = destruct(lr)
//       create(create(ll, lv, lrl), lrv, create(lrr, v, r))
//     }
//   } else if hr > hl + 2 {
//     let (rl, rv, rr) = destruct(r)
//     if height(rr) >= height(rl) {
//       create(create(l, v, rl), rv ,rr)
//     } else {
//       let (rll, rlv, rlr)=  destruct(rl)
//       create(create(l, v, rll), rlv, create(rlr,rv ,rr))
//     }
//   } else {
//     let h = max(hl, hr) + 1
//     create2(h, l, v, r)
//   }
// }

fn join_weight_balanced[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  create(l, v, r)
}

// fn join_neighbors[E](l: Tree[E], v: E, r: Tree[E]) -> Tree[E] {
//   bal(l, v, r)
// }

// fn join_quasi_siblings[E](l: Tree[E], v: E, r: Tree[E]) -> Tree[E] {
//   bal(l, v, r)
// }

// fn add_min_element[E](x: E, t: Tree[E]) -> Tree[E] {
//   match t {
//     TLeaf => singleton(x)
//     TNode (~l, ~v, ~r, ..) => bal(add_min_element(x, l), v, r)
//   }
// }

// fn add_max_element[E](x: E, t: Tree[E]) -> Tree[E] {
//   match t {
//     TLeaf => singleton(x)
//     TNode (~l, ~v, ~r, ..) => bal(l, v, add_max_element(x, r))
//   }
// }

fn scheme[E : Compare]() -> @base.Joinable[Tree[E], E] {
  {
    view,
    join,
    leaf,
    join_neighbors,
    join_weight_balanced,
    weight,
    cardinal,
    constant_time_cardinal,
    singleton,
    doubleton,
    tripleton,
    seems_smaller,
    check,
  }
}
