// This is an automatically generated template code

impl[K : Compare, V] Compare for Pair[K, V] with compare(
  self,
  other : Pair[K, V]
) {
  K::compare(self._.0, other._.0)
}

impl[K : Compare, V] Eq for Pair[K, V] with op_equal(self, other : Pair[K, V]) {
  self._.0 == other._.0
}

fn dummy[K, V : Default](k : K) -> Pair[K, V] {
  Pair((k, V::default()))
}

pub fn Map::empty[K : Compare, V]() -> Map[K, V] {
  scheme().empty()
}

pub fn Map::add[K : Compare, V](m : Map[K, V], k : K, v : V) -> Map[K, V] {
  scheme().add(Pair((k, v)), m._)
}

pub fn Map::update[K : Compare, V : Default](
  m : Map[K, V],
  k : K,
  f : (V?) -> V?
) -> Map[K, V] {
  let old_opt = scheme().find_opt(dummy(k), m._)
  match f(old_opt.map(fn(p) { p._.1 })) {
    Some(v) => scheme().add(Pair((k, v)), m._)
    None => scheme().remove(dummy(k), m._)
  }
}

pub fn Map::remove[K : Compare, V : Default](m : Map[K, V], k : K) -> Map[K, V] {
  scheme().remove(dummy(k), m._)
}

pub fn Map::remove_min_elt[K : Compare, V](m : Map[K, V]) -> Map[K, V]! {
  scheme().remove_min_elt!(m._)
}

pub fn Map::remove_max_elt[K : Compare, V](s : Map[K, V]) -> Map[K, V]! {
  scheme().remove_max_elt!(s._)
}

pub fn Map::union[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Map[K, V] {
  scheme().union(m1._, m2._)
}

pub fn Map::inter[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Map[K, V] {
  scheme().inter(m1._, m2._)
}

pub fn Map::diff[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Map[K, V] {
  scheme().diff(m1._, m2._)
}

pub fn Map::xor[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Map[K, V] {
  scheme().xor(m1._, m2._)
}

pub fn Map::split[K : Compare, V : Default](
  m : Map[K, V],
  k : K
) -> (Map[K, V], Bool, Map[K, V]) {
  let (l, b, r) = scheme().split(dummy(k), m._)
  (Map(l), b, Map(r))
}

pub fn Map::is_empty[K : Compare, V](m : Map[K, V]) -> Bool {
  scheme().is_empty(m._)
}

pub fn Map::min_binding[K : Compare, V](m : Map[K, V]) -> Pair[K, V]! {
  scheme().min_elt!(m._)
}

pub fn Map::min_binding_opt[K : Compare, V](m : Map[K, V]) -> Pair[K, V]? {
  scheme().min_elt_opt(m._)
}

pub fn Map::max_elt[K : Compare, V](m : Map[K, V]) -> Pair[K, V]! {
  scheme().max_elt!(m._)
}

pub fn Map::max_elt_opt[K : Compare, V](m : Map[K, V]) -> Pair[K, V]? {
  scheme().max_elt_opt(m._)
}

pub fn Map::choose[K : Compare, V](m : Map[K, V]) -> Pair[K, V]! {
  scheme().choose!(m._)
}

pub fn Map::choose_opt[K : Compare, V](m : Map[K, V]) -> Pair[K, V]? {
  scheme().choose_opt(m._)
}

pub fn Map::mem[K : Compare, V : Default](m : Map[K, V], x : K) -> Bool {
  scheme().mem(dummy(x), m._)
}

pub fn Map::find[K : Compare, V : Default](m : Map[K, V], x : K) -> V! {
  scheme().find!(dummy(x), m._)._.1
}

pub fn Map::find_opt[K : Compare, V : Default](
  s : Map[K, V],
  x : K
) -> V? {
  scheme().find_opt(dummy(x), s._).map(fn(p) { p._.1 })
}

pub fn Map::disjoint[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Bool {
  scheme().disjoint(m1._, m2._)
}

pub fn Map::equal[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Bool {
  scheme().equal(m1._, m2._)
}

pub fn Map::compare[K : Compare, V](m1 : Map[K, V], m2 : Map[K, V]) -> Int {
  scheme().compare(m1._, m2._)
}

pub fn Map::of_list[K : Compare, V](xs : List[(K, V)]) -> Map[K, V] {
  scheme().of_list(xs.map(fn(p) { Pair(p) }))
}

pub fn Map::to_list[K : Compare, V](m : Map[K, V]) -> List[(K, V)] {
  scheme().to_list(m._).map(fn(p) { p._ })
}

pub fn Map::elements[K : Compare, V](s : Map[K, V]) -> List[(K, V)] {
  scheme().elements(s._).map(fn(p) { p._ })
}

pub fn Map::of_array[K : Compare, V](a : Array[(K, V)]) -> Map[K, V] {
  scheme().of_array(a.map(fn(p) { Pair(p) }))
}

pub fn Map::to_array[K : Compare, V](m : Map[K, V]) -> Array[(K, V)] {
  scheme().to_array(m._).map(fn(p) { p._ })
}

// TODO: rename the method
pub fn Map::iter_[K : Compare, V](m : Map[K, V], f : ((K, V)) -> Unit) -> Unit {
  scheme().iter(fn(p : Pair[K, V]) { f(p._) }, m._)
}

pub fn Map::fold[K : Compare, V, A](
  m : Map[K, V],
  f : ((K, V), A) -> A,
  accu : A
) -> A {
  scheme().fold(fn(p : Pair[K, V], accu : A) { f(p._, accu) }, m._, accu)
}

pub fn Map::for_all[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> Bool {
  scheme().for_all(fn(pa : Pair[K, V]) { p(pa._) }, m._)
}

pub fn Map::exists[K : Compare, V](m : Map[K, V], p : ((K, V)) -> Bool) -> Bool {
  scheme().exists(fn(pa : Pair[K, V]) { p(pa._) }, m._)
}

pub fn Map::find_first[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> (K, V)! {
  scheme().find_first!(fn(pa : Pair[K, V]) { p(pa._) }, m._)._
}

pub fn Map::find_first_opt[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> (K, V)? {
  scheme()
  .find_first_opt(fn(pa : Pair[K, V]) { p(pa._) }, m._)
  .map(fn(pa) { pa._ })
}

pub fn Map::find_last[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> (K, V)! {
  scheme().find_last!(fn(pa : Pair[K, V]) { p(pa._) }, m._)._
}

pub fn Map::find_last_opt[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> (K, V)? {
  scheme()
  .find_last_opt(fn(pa : Pair[K, V]) { p(pa._) }, m._)
  .map(fn(pa) { pa._ })
}

pub fn Map::map[K : Compare, V](
  m : Map[K, V],
  f : ((K, V)) -> (K, V)
) -> Map[K, V] {
  scheme().map(fn(p) { Pair(f(p._)) }, m._)
}

pub fn Map::filter[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> Map[K, V] {
  scheme().filter(fn(pa : Pair[K, V]) { p(pa._) }, m._)
}

pub fn Map::filter_map[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> (K, V)?
) -> Map[K, V]! {
  scheme().filter_map!(
    fn(pa : Pair[K, V]) { p(pa._).map(fn(pa) { Pair(pa) }) },
    m._,
  )
}

pub fn Map::partition[K : Compare, V](
  m : Map[K, V],
  p : ((K, V)) -> Bool
) -> (Map[K, V], Map[K, V]) {
  let (l, r) = scheme().partition(fn(pa : Pair[K, V]) { p(pa._) }, m._)
  (Map(l), Map(r))
}

pub fn Map::get[K : Compare, V](m : Map[K, V], i : Int) -> (K, V)! {
  scheme().get!(m._, i)._
}

pub fn Map::index[K : Compare, V](m : Map[K, V], x : (K, V)) -> Int! {
  scheme().index!(Pair(x), m._)
}

pub fn Map::cut[K : Compare, V](
  m : Map[K, V],
  i : Int
) -> (Map[K, V], Map[K, V])! {
  let (l, r) = scheme().cut!(m._, i)
  (Map(l), Map(r))
}

pub fn Map::cut_and_get[K : Compare, V](
  s : Map[K, V],
  i : Int
) -> (Map[K, V], (K, V), Map[K, V])! {
  let (l, v, r) = scheme().cut_and_get!(s._, i)
  (Map(l), v._, Map(r))
}

pub fn Map::iter[K, V](s : Map[K, V]) -> Iter[(K, V)] {
  Iter::new(
    fn(yield_) {
      match s._ {
        TLeaf => IterContinue
        TNode(~l, ~v, ~r, ..) => {
          let l = Map(l)
          let r = Map(r)
          if l.iter().run(yield_) == IterEnd {
            return IterEnd
          } else if yield_(v._) == IterEnd {
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

// TODO: 
// pub fn Map::merge
// pub fn Map::union - rewrite
// pub fn Map::bindings
// pub fn Map::iter_ - rename
// pub fn Map::map - rewrite
// pub fn Map::mapi
// pub fn Map::equal - rewrite
// pub fn Map::compare - rewrite
// pub fn Map::cardinal