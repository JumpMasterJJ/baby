pub fn Set::empty[E : Compare]() -> Set[E] {
  scheme().empty()
}

pub fn Set::add[E : Compare](s : Set[E], x : E) -> Set[E] {
  scheme().add(x, s._)
}

pub fn Set::remove[E : Compare](s : Set[E], x : E) -> Set[E] {
  scheme().remove(x, s._)
}

pub fn Set::remove_min_elt[E : Compare](s : Set[E]) -> Set[E]! {
  scheme().remove_min_elt!(s._)
}

pub fn Set::remove_max_elt[E : Compare](s : Set[E]) -> Set[E]! {
  scheme().remove_max_elt!(s._)
}

pub fn Set::union[E : Compare](s1 : Set[E], s2 : Set[E]) -> Set[E] {
  scheme().union(s1._, s2._)
}

pub fn Set::inter[E : Compare](s1 : Set[E], s2 : Set[E]) -> Set[E] {
  scheme().inter(s1._, s2._)
}

pub fn Set::diff[E : Compare](s1 : Set[E], s2 : Set[E]) -> Set[E] {
  scheme().diff(s1._, s2._)
}

pub fn Set::xor[E : Compare](s1 : Set[E], s2 : Set[E]) -> Set[E] {
  scheme().xor(s1._, s2._)
}

pub fn Set::split[E : Compare](s : Set[E], k : E) -> (Set[E], Bool, Set[E]) {
  let (l, b, r) = scheme().split(k, s._)
  (Set(l), b, Set(r))
}

pub fn Set::is_empty[E : Compare](s : Set[E]) -> Bool {
  scheme().is_empty(s._)
}

pub fn Set::min_elt[E : Compare](s : Set[E]) -> E! {
  scheme().min_elt!(s._)
}

pub fn Set::min_elt_opt[E : Compare](s : Set[E]) -> E? {
  scheme().min_elt_opt(s._)
}

pub fn Set::max_elt[E : Compare](s : Set[E]) -> E! {
  scheme().max_elt!(s._)
}

pub fn Set::max_elt_opt[E : Compare](s : Set[E]) -> E? {
  scheme().max_elt_opt(s._)
}

pub fn Set::choose[E : Compare](s : Set[E]) -> E! {
  scheme().choose!(s._)
}

pub fn Set::choose_opt[E : Compare](s : Set[E]) -> E? {
  scheme().choose_opt(s._)
}

pub fn Set::mem[E : Compare](s : Set[E], x : E) -> Bool {
  scheme().mem(x, s._)
}

pub fn Set::find[E : Compare](s : Set[E], x : E) -> E! {
  scheme().find!(x, s._)
}

pub fn Set::find_opt[E : Compare](s : Set[E], x : E) -> E? {
  scheme().find_opt(x, s._)
}

pub fn Set::disjoint[E : Compare](s1 : Set[E], s2 : Set[E]) -> Bool {
  scheme().disjoint(s1._, s2._)
}

pub fn Set::subset[E : Compare](s1 : Set[E], s2 : Set[E]) -> Bool {
  scheme().subset(s1._, s2._)
}

pub fn Set::equal[E : Compare](s1 : Set[E], s2 : Set[E]) -> Bool {
  scheme().equal(s1._, s2._)
}

pub fn Set::compare[E : Compare](s1 : Set[E], s2 : Set[E]) -> Int {
  scheme().compare(s1._, s2._)
}

pub fn Set::of_list[E : Compare](xs : List[E]) -> Set[E] {
  scheme().of_list(xs)
}

pub fn Set::to_list[E : Compare](s : Set[E]) -> List[E] {
  scheme().to_list(s._)
}

pub fn Set::elements[E : Compare](s : Set[E]) -> List[E] {
  scheme().elements(s._)
}

pub fn Set::of_array[E : Compare](a : Array[E]) -> Set[E] {
  scheme().of_array(a)
}

pub fn Set::to_array[E : Compare](s : Set[E]) -> Array[E] {
  scheme().to_array(s._)
}

// TODO: scheme().to_seq
// TODO: scheme().to_seq_from
// TODO: scheme().to_rev_seq

// TODO: rename the method
pub fn Set::iter_[E : Compare](s : Set[E], f : (E) -> Unit) -> Unit {
  scheme().iter(f, s._)
}

pub fn Set::fold[E : Compare, A](s : Set[E], f : (E, A) -> A, accu : A) -> A {
  scheme().fold(f, s._, accu)
}

pub fn Set::for_all[E : Compare](s : Set[E], p : (E) -> Bool) -> Bool {
  scheme().for_all(p, s._)
}

pub fn Set::exists[E : Compare](s : Set[E], p : (E) -> Bool) -> Bool {
  scheme().exists(p, s._)
}

pub fn Set::find_first[E : Compare](s : Set[E], p : (E) -> Bool) -> E! {
  scheme().find_first!(p, s._)
}

pub fn Set::find_first_opt[E : Compare](s : Set[E], p : (E) -> Bool) -> E? {
  scheme().find_first_opt(p, s._)
}

pub fn Set::find_last[E : Compare](s : Set[E], p : (E) -> Bool) -> E! {
  scheme().find_last!(p, s._)
}

pub fn Set::find_last_opt[E : Compare](s : Set[E], p : (E) -> Bool) -> E? {
  scheme().find_last_opt(p, s._)
}

pub fn Set::map[E : Compare](s : Set[E], f : (E) -> E) -> Set[E] {
  scheme().map(f, s._)
}

pub fn Set::filter[E : Compare](s : Set[E], p : (E) -> Bool) -> Set[E] {
  scheme().filter(p, s._)
}

pub fn Set::filter_map[E : Compare](s : Set[E], p : (E) -> E?) -> Set[E]! {
  scheme().filter_map!(p, s._)
}

pub fn Set::partition[E : Compare](
  s : Set[E],
  p : (E) -> Bool
) -> (Set[E], Set[E]) {
  let (l, r) = scheme().partition(p, s._)
  (Set(l), Set(r))
}

pub fn Set::get[E : Compare](s : Set[E], i : Int) -> E! {
  scheme().get!(s._, i)
}

pub fn Set::index[E : Compare](s : Set[E], x : E) -> Int! {
  scheme().index!(x, s._)
}

pub fn Set::cut[E : Compare](s : Set[E], i : Int) -> (Set[E], Set[E])! {
  let (l, r) = scheme().cut!(s._, i)
  (Set(l), Set(r))
}

pub fn Set::cut_and_get[E : Compare](
  s : Set[E],
  i : Int
) -> (Set[E], E, Set[E])! {
  let (l, v, r) = scheme().cut_and_get!(s._, i)
  (Set(l), v, Set(r))
}

pub fn Set::iter[E](s : Set[E]) -> Iter[E] {
  Iter::new(
    fn(yield_) {
      match s._ {
        TLeaf => IterContinue
        TNode(~l, ~v, ~r, ..) => {
          let l = Set(l)
          let r = Set(r)
          if l.iter().run(yield_) == IterEnd {
            return IterEnd
          } else if yield_(v) == IterEnd {
            return IterEnd
          } else if r.iter().run(yield_) == IterEnd {
            return IterEnd
          } else {
            return IterContinue
          }
        }
      }
    },
  )
}

// TODO: enum module
