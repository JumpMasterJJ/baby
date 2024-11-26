typealias View[T, E] = @base.View[T, E]

typealias List[E] = @immut/list.T[E]

type Set[E] Tree[E]

type Pair[A, B] (A, B)

type Map[K, V] Tree[Pair[K, V]]
