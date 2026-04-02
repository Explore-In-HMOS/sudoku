import { Cell, Level } from '../models/SudokuModel'
import { generateBoard } from '../utils/SudokuGenerator'
import { checkConflicts, checkWin } from '../utils/SudokuValidator'
import { SudokuColors } from '../utils/SudokuColors'

@ObservedV2
export class GameViewModel {
  @Trace board: Cell[][] = []
  @Trace level: Level = Level.EASY
  @Trace selectedRow: number = -1
  @Trace selectedCol: number = -1

  @Trace isGameWon: boolean = false
  @Trace showWinDialog: boolean = false

  @Trace elapsedSeconds: number = 0
  private timerId: number = -1

  private crownCumulativeDegree: number = 0
  private readonly crownThreshold: number = 20

  onBoardChanged: (board: Cell[][]) => void = () => {}

  private notifyBoardChanged(): void {
    this.board = [...this.board]
    this.onBoardChanged(this.board)
  }

  initGame(level: Level): void {
    this.level = level
    this.board = generateBoard(this.level)
    this.selectedRow = -1
    this.selectedCol = -1
    this.isGameWon = false
    this.showWinDialog = false
    this.elapsedSeconds = 0
    this.crownCumulativeDegree = 0
    this.startTimer()
    this.onBoardChanged(this.board)
  }

  dispose(): void {
    this.stopTimer()
  }

  private startTimer(): void {
    this.stopTimer()
    this.timerId = setInterval(() => {
      if (!this.isGameWon) {
        this.elapsedSeconds++
      }
    }, 1000)
  }

  private stopTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  formatTime(): string {
    const minutes: number = Math.floor(this.elapsedSeconds / 60)
    const seconds: number = this.elapsedSeconds % 60
    const mm: string = minutes < 10 ? `0${minutes}` : `${minutes}`
    const ss: string = seconds < 10 ? `0${seconds}` : `${seconds}`
    return `${mm}:${ss}`
  }

  private setCellValue(row: number, col: number, direction: number): void {
    if (this.isGameWon) {
      return
    }

    const cell: Cell = this.board[row][col]
    if (cell.isFixed) {
      return
    }

    let newValue: number = cell.value + direction
    if (newValue > 6) {
      newValue = 0
    } else if (newValue < 0) {
      newValue = 6
    }

    cell.value = newValue
    cell.tapCount = newValue

    checkConflicts(this.board)
    this.notifyBoardChanged()

    if (checkWin(this.board)) {
      this.isGameWon = true
      this.stopTimer()
      this.showWinDialog = true
    }
  }

  onCellTap(row: number, col: number): void {
    if (this.isGameWon) {
      return
    }

    const cell: Cell = this.board[row][col]
    if (cell.isFixed) {
      return
    }

    this.selectedRow = row
    this.selectedCol = col
    this.setCellValue(row, col, 1)
  }

  onCrownEvent(event: CrownEvent): void {
    event.stopPropagation()

    if (this.isGameWon) {
      return
    }
    if (this.selectedRow < 0 || this.selectedCol < 0) {
      return
    }

    const cell: Cell = this.board[this.selectedRow][this.selectedCol]
    if (cell.isFixed) {
      return
    }

    this.crownCumulativeDegree += event.degree

    if (Math.abs(this.crownCumulativeDegree) >= this.crownThreshold) {
      const direction: number = this.crownCumulativeDegree > 0 ? -1 : 1
      this.setCellValue(this.selectedRow, this.selectedCol, direction)
      this.crownCumulativeDegree = 0
    }
  }

  restartGame(): void {
    this.initGame(this.level)
  }

  getLevelColor(): string {
    switch (this.level) {
      case Level.EASY:
        return SudokuColors.EASY_TEXT
      case Level.MEDIUM:
        return SudokuColors.MEDIUM_TEXT
      case Level.HARD:
        return SudokuColors.HARD_TEXT
      default:
        return SudokuColors.TEXT_PRIMARY
    }
  }
}
