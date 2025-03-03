fn max(x : Int, y : Int) -> Int {
  if x <= y {
    y
  } else {
    x
  }
}

fn Tree::height[E](t : Tree[E]) -> Int {
  match t {
    TLeaf => 0
    TNode(~h, ..) => h
  }
}

fn Tree::weight[E](t : Tree[E]) -> Int {
  0
}

fn Tree::view[E](t : Tree[E]) -> View[Tree[E], E] {
  match t {
    TLeaf => Leaf
    TNode(~l, ~v, ~r, ..) => Node(l, v, r)
  }
}

fn Tree::leaf[E]() -> Tree[E] {
  TLeaf
}

let constant_time_cardinal = false

fn Tree::cardinal[E](t : Tree[E]) -> Int {
  fn aux(accu, t) {
    match t {
      TLeaf => accu
      TNode(~l, ~r, ..) => {
        let accu = accu + 1
        let accu = aux(accu, l)
        aux(accu, r)
      }
    }
  }

  aux(0, t)
}

fn Tree::siblings[E](l : Tree[E], r : Tree[E]) -> Bool {
  Int::abs(height(l) - height(r)) <= 2
}

fn Tree::quasi_siblings[E](l : Tree[E], r : Tree[E]) -> Bool {
  Int::abs(height(l) - height(r)) <= 3
}

fn Tree::check[E](t : Tree[E]) -> Unit {
  match t {
    TLeaf => ()
    TNode(~l, ~r, ~h, ..) => {
      check(l)
      check(r)
      guard h == max(height(l), height(r)) + 1
      guard siblings(l, r)

    }
  }
}

fn Tree::create2[E](h : Int, l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  guard siblings(l, r)
  guard h == max(height(l), height(r)) + 1
  TNode(~l, ~v, ~r, ~h)
}

fn Tree::create[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  let h = max(height(l), height(r)) + 1
  create2(h, l, v, r)
}

fn Tree::join_siblings[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  create(l, v, r)
}

fn Tree::singleton[E](x : E) -> Tree[E] {
  let h = 1
  create2(1, TLeaf, x, TLeaf)
}

fn Tree::doubleton[E](x : E, y : E) -> Tree[E] {
  let h = 2
  create2(h, TLeaf, x, singleton(y))
}

fn Tree::tripleton[E](x : E, y : E, z : E) -> Tree[E] {
  let h = 2
  create2(h, singleton(x), y, singleton(z))
}

// TODO: fn Tree::of_sorted_unique_array_slice

fn Tree::seems_smaller[E](t1 : Tree[E], t2 : Tree[E]) -> Bool {
  match (t1, t2) {
    (TLeaf, TLeaf) => false
    (TLeaf, _) => true
    (_, TLeaf) => false
    (TNode(h=h1, ..), TNode(h=h2, ..)) => h1 < h2
  }
}

fn Tree::destruct[E](t : Tree[E]) -> (Tree[E], E, Tree[E]) {
  guard let TNode(~l, ~v, ~r, ..) = t
  (l, v, r)
}

fn Tree::bal[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  guard quasi_siblings(l, r)
  let hl = height(l)
  let hr = height(r)
  if hl > hr + 2 {
    let (ll, lv, lr) = destruct(l)
    if height(ll) >= height(lr) {
      create(ll, lv, create(lr, v, r))
    } else {
      let (lrl, lrv, lrr) = destruct(lr)
      create(create(ll, lv, lrl), lrv, create(lrr, v, r))
    }
  } else if hr > hl + 2 {
    let (rl, rv, rr) = destruct(r)
    if height(rr) >= height(rl) {
      create(create(l, v, rl), rv, rr)
    } else {
      let (rll, rlv, rlr) = destruct(rl)
      create(create(l, v, rll), rlv, create(rlr, rv, rr))
    }
  } else {
    let h = max(hl, hr) + 1
    create2(h, l, v, r)
  }
}

fn Tree::join_weight_balanced[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  create(l, v, r)
}

fn Tree::join_neighbors[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  bal(l, v, r)
}

fn Tree::join_quasi_siblings[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  bal(l, v, r)
}

fn Tree::add_min_element[E](x : E, t : Tree[E]) -> Tree[E] {
  match t {
    TLeaf => singleton(x)
    TNode(~l, ~v, ~r, ..) => bal(add_min_element(x, l), v, r)
  }
}

fn Tree::add_max_element[E](x : E, t : Tree[E]) -> Tree[E] {
  match t {
    TLeaf => singleton(x)
    TNode(~l, ~v, ~r, ..) => bal(l, v, add_max_element(x, r))
  }
}

fn Tree::join[E](l : Tree[E], v : E, r : Tree[E]) -> Tree[E] {
  match (l, r) {
    (TLeaf, _) => add_min_element(v, r)
    (_, TLeaf) => add_max_element(v, l)
    (TNode(l=ll, v=lv, r=lr, h=hl), TNode(l=rl, v=rv, r=rr, h=hr)) =>
      if hl > hr + 2 {
        bal(ll, lv, join(lr, v, r))
      } else if hr > hl + 2 {
        bal(join(l, v, rl), rv, rr)
      } else {
        create(l, v, r)
      }
  }
}

fn Tree::scheme[E : Compare]() -> @base.Joinable[Tree[E], E] {
  let cardinal = Tree::cardinal
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
