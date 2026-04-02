import { Cell } from '../models/SudokuModel'
import { SudokuColors } from '../utils/SudokuColors'

@Component
export struct SudokuCell {
  @ObjectLink cellData: Cell
  @Prop row: number = 0
  @Prop col: number = 0
  @Prop isSelected: boolean = false
  @Prop cellSize: number = 0
  onCellTap: (row: number, col: number) => void = () => {
  }
  threshold: number = 10;

  private getCellBackground(): string {
    if (this.cellData.isError && this.cellData.value !== 0) {
      return SudokuColors.CELL_ERROR_BG
    }
    if (this.isSelected && !this.cellData.isFixed) {
      return SudokuColors.CELL_SELECTED_BG
    }
    if (this.cellData.isFixed) {
      return SudokuColors.CELL_FIXED_BG
    }
    return SudokuColors.CELL_BG
  }

  private getCellTextColor(): string {
    if (this.cellData.isError && this.cellData.value !== 0) {
      return SudokuColors.TEXT_ERROR
    }
    if (this.cellData.isFixed) {
      return SudokuColors.TEXT_GIVEN
    }
    return SudokuColors.TEXT_PRIMARY
  }

  private getRightBorderWidth(): number {
    if (this.col === 2 || this.col === 5) {
      return 1.5
    }
    return 0.5
  }

  private getBottomBorderWidth(): number {
    if (this.row === 1 || this.row === 3 || this.row === 5) {
      return 1.5
    }
    return 0.5
  }

  build() {
    Column() {
      if (this.cellData.value !== 0) {
        Text(`${this.cellData.value}`)
          .fontSize(18)
          .fontWeight(this.cellData.isFixed ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.getCellTextColor())
      }
    }
    .width(this.cellSize)
    .height(this.cellSize)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.getCellBackground())
    .border({
      width: {
        right: this.getRightBorderWidth(),
        bottom: this.getBottomBorderWidth(),
        left: this.col === 0 ? 1.5 : 0.5,
        top: this.row === 0 ? 1.5 : 0.5
      },
      color: {
        right: (this.col === 2 || this.col === 5) ? SudokuColors.BORDER_BLOCK : SudokuColors.BORDER_CELL,
        bottom: (this.row === 1 || this.row === 3 || this.row === 5) ? SudokuColors.BORDER_BLOCK :
        SudokuColors.BORDER_CELL,
        left: this.col === 0 ? SudokuColors.BORDER_BLOCK : SudokuColors.BORDER_CELL,
        top: this.row === 0 ? SudokuColors.BORDER_BLOCK : SudokuColors.BORDER_CELL
      }
    })
    .onClick(() => {
      if (!this.cellData.isFixed) {
        this.onCellTap(this.row, this.col)
      }
    })
  }
}
