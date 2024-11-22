// TODO: only allow to operate on set, more abstract for map

pub fn Enum::empty[T, E]() -> Enum[T, E] {
  End
}

pub fn Enum::is_empty[T, E](e : Enum[T, E]) -> Bool {
  match e {
    End => true
    More(_) => false
  }
}

pub fn Enum::cat_tree_enum[T, E](
  scheme : Joinable[T, E],
  t : T,
  e : Enum[T, E]
) -> Enum[T, E] {
  let view = scheme.view
  match view(t) {
    Leaf => e
    Node(l, v, r) => cat_tree_enum(scheme, l, More(v, r, e))
  }
}

// TODO: rename ?
pub fn Enum::enum_[T, E](scheme : Joinable[T, E], t : T) -> Enum[T, E] {
  cat_tree_enum(scheme, t, Enum::empty())
}

pub fn Enum::filter_tree[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  t : T,
  e : Enum[T, E]
) -> Enum[T, E] {
  let view = scheme.view
  match view(t) {
    Leaf => e
    Node(l, v, r) => {
      let c = E::compare(v, low)
      if c == 0 {
        More(v, r, e)
      } else if c < 0 {
        filter_tree(scheme, low, r, e)
      } else {
        filter_tree(scheme, low, l, More(v, r, e))
      }
    }
  }
}

pub fn Enum::from_enum[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  t : T
) -> Enum[T, E] {
  filter_tree(scheme, low, t, Enum::empty())
}

pub fn Enum::filter_tree_enum[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  r : T,
  e : Enum[T, E]
) -> Enum[T, E] {
  match e {
    More(v_, r_, e_) => {
      let c = E::compare(low, v_)
      if c > 0 {
        filter_tree_enum(scheme, low, r_, e_)
      } else if c == 0 {
        e
      } else {
        filter_tree(scheme, low, r, e)
      }
    }
    End => filter_tree(scheme, low, r, e)
  }
}

pub fn Enum::from[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  e : Enum[T, E]
) -> Enum[T, E] {
  match e {
    More(v, r, e_) =>
      if E::compare(low, v) <= 0 {
        e
      } else {
        filter_tree_enum(scheme, low, r, e_)
      }
    End => End
  }
}

pub fn Enum::head[T, E](e : Enum[T, E]) -> E!Not_found {
  match e {
    End => raise Not_found
    More(v, _, _) => v
  }
}

pub fn Enum::tail[T, E](
  scheme : Joinable[T, E],
  e : Enum[T, E]
) -> Enum[T, E]!Not_found {
  match e {
    End => raise Not_found
    More(_, r, e) => cat_tree_enum(scheme, r, e)
  }
}

pub fn Enum::head_opt[T, E](e : Enum[T, E]) -> E? {
  match e {
    End => None
    More(v, _, _) => Some(v)
  }
}

pub fn Enum::tail_opt[T, E](
  scheme : Joinable[T, E],
  e : Enum[T, E]
) -> Enum[T, E]? {
  match e {
    End => None
    More(_, r, e) => Some(cat_tree_enum(scheme, r, e))
  }
}

pub fn Enum::equal[T, E : Compare](
  scheme : Joinable[T, E],
  e1 : Enum[T, E],
  e2 : Enum[T, E]
) -> Bool {
  match (e1, e2) {
    (End, End) => true
    (End, More(_)) | (More(_), End) => false
    (More(v1, r1, e1), More(v2, r2, e2)) =>
      E::compare(v1, v2) == 0 &&
      Enum::equal(
        scheme,
        cat_tree_enum(scheme, r1, e1),
        cat_tree_enum(scheme, r2, e2),
      )
  }
}

pub fn Enum::compare[T, E : Compare](
  scheme : Joinable[T, E],
  e1 : Enum[T, E],
  e2 : Enum[T, E]
) -> Int {
  match (e1, e2) {
    (End, End) => 0
    (End, More(_)) => -1
    (More(_), End) => 1
    (More(v1, r1, e1), More(v2, r2, e2)) => {
      let c = E::compare(v1, v2)
      if c != 0 {
        c
      } else {
        Enum::compare(
          scheme,
          cat_tree_enum(scheme, r1, e1),
          cat_tree_enum(scheme, r2, e2),
        )
      }
    }
  }
}

// TODO: There is no sequence in MoonBit
// fn IEnum::to_seq_node[T, E](e: IEnum[T, E]) -> Seq[E]
// fn IEum::to_seq[T, E](e: IEnum[T, E]) -> Seq[E]

pub fn Enum::elements[T, E](scheme : Joinable[T, E], e : Enum[T, E]) -> T {
  let leaf = scheme.leaf
  let join = scheme.join
  fn aux(v, r, e) -> T {
    match e {
      End => join(leaf(), v, r)
      More(v_, r_, e) => aux(v, join(r, v_, r_), e)
    }
  }

  match e {
    End => leaf()
    More(v, r, e) => aux(v, r, e)
  }
}

pub fn Enum::filter_tree_disjoint[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  t : T,
  e : Enum[T, E]
) -> Enum[T, E]!Not_disjoint {
  let view = scheme.view
  match view(t) {
    Leaf => e
    Node(l, v, r) => {
      let c = E::compare(v, low)
      if c == 0 {
        raise Not_disjoint
      } else if c < 0 {
        filter_tree_disjoint!(scheme, low, r, e)
      } else {
        filter_tree_disjoint!(scheme, low, l, More(v, r, e))
      }
    }
  }
}

pub fn filter_tree_enum_disjoint[T, E : Compare](
  scheme : Joinable[T, E],
  low : E,
  r : T,
  e : Enum[T, E]
) -> Enum[T, E]!Not_disjoint {
  match e {
    More(v_, r_, e_) => {
      let c = E::compare(low, v_)
      if c > 0 {
        filter_tree_enum_disjoint!(scheme, low, r_, e_)
      } else if c == 0 {
        raise Not_disjoint
      } else {
        filter_tree_disjoint!(scheme, low, r, e)
      }
    }
    End => filter_tree_disjoint!(scheme, low, r, e)
  }
}

fn Enum::disjoint_more_more[T, E : Compare](
  scheme : Joinable[T, E],
  v1 : E,
  r1 : T,
  e1 : Enum[T, E],
  v2 : E,
  r2 : T,
  e2 : Enum[T, E]
) -> Bool!Not_disjoint {
  guard E::compare(v1, v2) < 0
  let e1 = filter_tree_enum_disjoint!(scheme, v2, r1, e1)
  match e1 {
    End => true
    More(v1, r1, e1) => {
      guard E::compare(v2, v1) < 0
      disjoint_more_more!(scheme, v2, r2, e2, v1, r1, e1)
    }
  }
}

pub fn Enum::disjoint[T, E : Compare](
  scheme : Joinable[T, E],
  e1 : Enum[T, E],
  e2 : Enum[T, E]
) -> Bool {
  match (e1, e2) {
    (End, _) | (_, End) => true
    (More(v1, r1, e1), More(v2, r2, e2)) => {
      let c = E::compare(v1, v2)
      if c == 0 {
        false
      } else {
        try {
          if c < 0 {
            disjoint_more_more!(scheme, v1, r1, e1, v2, r2, e2)
          } else {
            disjoint_more_more!(scheme, v2, r2, e2, v1, r1, e1)
          }
        } catch {
          Not_disjoint => false
        }
      }
    }
  }
}

pub fn Enum::length[T, E](scheme : Joinable[T, E], e : Enum[T, E]) -> Int {
  let cardinal = scheme.cardinal
  fn aux(accu, e) {
    match e {
      End => accu
      More(_, r, e) => aux(accu + cardinal(r) + 1, e)
    }
  }

  aux(0, e)
}

// TODO: module RevEnum
