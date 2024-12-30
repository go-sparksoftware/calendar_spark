typedef Cell = ({int row, int column});

extension CellExtension on Cell {
  Cell get nextColumn => (row: row, column: column + 1);
}
