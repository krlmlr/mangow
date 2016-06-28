# mangow 0.1-1 (2016-06-28)

- Columns with only one value are not represented in the result matrix.
- Tests don't show bogus warnings issued by `cluster::daisy()` anymore.


# mangow 0.1 (2016-06-28)

Initial GitHub release.

- Function `mangow()` converts a Gower's distance problem to a Manhattan distance problem.
- Use row names from input dataset, and proper column names.
- Test compatibility with `StatMatch`.
- Error message shows offending column name.
