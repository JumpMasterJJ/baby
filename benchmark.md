## benchmark 结果

### 相同策略 - baby v.s. stdlib
1. slightly fast - inline + fast path + specialized function
  1. add - inline
  2. split13 - physical equal & spcialized function (reduce the return values)
  3. inter - specicalized code (instead use more efficient function in some environment)
3. much fast - fast path（much faster on the special circumstance, 比如Common场景）
```OCaml
(* Our implementation of [union] is in the same style as [inter].
   It inherits two features of OCaml's Set library:
   - the tree that seems smaller is split;
   - if a subtree is a singleton then [union] degenerates to [add].
   Furthermore, compared with OCaml's Set library, it is able to exploit
   physical equality when present, and it offers a stronger guarantee
   regarding the preservation of physical equality. *)
```

### 不同策略 - height v.s. weight
1. 论文中也是有提及WBT拥有一点点的性能领先，但是他将其解释为WBT不需要额外的字段来存储size信息（用于某些随机访问操作）。
  但是在baby中HBT中没有存储size信息，依然比WBT稍微慢一点（不太清楚为什么，baby中也没有对此说明）。
2. 对于某些随机访问操作以及相关操作，显然是要快上许多。
