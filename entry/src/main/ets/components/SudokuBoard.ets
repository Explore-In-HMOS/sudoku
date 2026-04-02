import { Cell } from '../models/SudokuModel'
import { SudokuColors } from '../utils/SudokuColors'
import { SudokuCell } from './SudokuCell'

@Component
export struct SudokuBoard {
  @Link board: Cell[][]
  @Prop selectedRow: number = -1
  @Prop selectedCol: number = -1
  onCellTap: (row: number, col: number) => void = () => {}

  build() {
    Column() {
      ForEach(this.board, (rowCells: Cell[]) => {
        Row() {
          ForEach(rowCells, (cell: Cell) => {
            SudokuCell({
              cellData: cell,
              row: cell.row,
              col: cell.col,
              isSelected: (this.selectedRow === cell.row && this.selectedCol === cell.col),
              cellSize: 25,
              onCellTap: this.onCellTap
            })
          }, (cell: Cell): string => cell.id)
        }
      }, (rowCells: Cell[]): string => rowCells[0].id)
    }
    .border({
      width: 2,
      color: SudokuColors.BORDER_BLOCK
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)

  }
}
