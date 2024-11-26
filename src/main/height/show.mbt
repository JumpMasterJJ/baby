pub impl[E : Show] Show for Set[E] with output(self, logger) {
  logger.write_iter(self.iter(), prefix="@height.Set::of_array([", suffix="])")
}

pub fn to_string[E : Show](self : Set[E]) -> String {
  Show::to_string(self)
}
