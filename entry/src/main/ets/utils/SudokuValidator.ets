import { Cell } from '../models/SudokuModel'

const SIZE: number = 6
const BOX_ROWS: number = 2
const BOX_COLS: number = 3

export function isValidPlacement(grid: number[][], row: number, col: number, val: number): boolean {

  for (let c: number = 0; c < SIZE; c++) {
    if (grid[row][c] === val) {
      return false
    }
  }

  for (let r: number = 0; r < SIZE; r++) {
    if (grid[r][col] === val) {
      return false
    }
  }

  const boxRow: number = Math.floor(row / BOX_ROWS) * BOX_ROWS
  const boxCol: number = Math.floor(col / BOX_COLS) * BOX_COLS
  for (let r: number = boxRow; r < boxRow + BOX_ROWS; r++) {
    for (let c: number = boxCol; c < boxCol + BOX_COLS; c++) {
      if (grid[r][c] === val) {
        return false
      }
    }
  }

  return true
}

export function isGridComplete(grid: number[][]): boolean {
  for (let r: number = 0; r < SIZE; r++) {
    for (let c: number = 0; c < SIZE; c++) {
      if (grid[r][c] === 0) {
        return false
      }
    }
  }
  return true
}

export function countSolutions(grid: number[][], maxCount: number): number {
  let emptyRow: number = -1
  let emptyCol: number = -1
  let found: boolean = false

  for (let r: number = 0; r < SIZE; r++) {
    for (let c: number = 0; c < SIZE; c++) {
      if (grid[r][c] === 0) {
        emptyRow = r
        emptyCol = c
        found = true
        break
      }
    }
    if (found) {
      break
    }
  }

  if (!found) {
    return 1
  }

  let count: number = 0
  for (let val: number = 1; val <= SIZE; val++) {
    if (isValidPlacement(grid, emptyRow, emptyCol, val)) {
      grid[emptyRow][emptyCol] = val
      count += countSolutions(grid, maxCount - count)
      grid[emptyRow][emptyCol] = 0

      if (count >= maxCount) {
        return count
      }
    }
  }

  return count
}

export function hasUniqueSolution(grid: number[][]): boolean {
  const copy: number[][] = []
  for (let r: number = 0; r < SIZE; r++) {
    const row: number[] = []
    for (let c: number = 0; c < SIZE; c++) {
      row.push(grid[r][c])
    }
    copy.push(row)
  }
  return countSolutions(copy, 2) === 1
}

export function checkConflicts(board: Cell[][]): void {
  for (let r: number = 0; r < SIZE; r++) {
    for (let c: number = 0; c < SIZE; c++) {
      board[r][c].isError = false
    }
  }

  for (let r: number = 0; r < SIZE; r++) {
    for (let c: number = 0; c < SIZE; c++) {
      const val: number = board[r][c].value
      if (val === 0) {
        continue
      }

      for (let cc: number = 0; cc < SIZE; cc++) {
        if (cc !== c && board[r][cc].value === val) {
          board[r][c].isError = true
          board[r][cc].isError = true
        }
      }

      for (let rr: number = 0; rr < SIZE; rr++) {
        if (rr !== r && board[rr][c].value === val) {
          board[r][c].isError = true
          board[rr][c].isError = true
        }
      }

      const boxRow: number = Math.floor(r / BOX_ROWS) * BOX_ROWS
      const boxCol: number = Math.floor(c / BOX_COLS) * BOX_COLS
      for (let rr: number = boxRow; rr < boxRow + BOX_ROWS; rr++) {
        for (let cc: number = boxCol; cc < boxCol + BOX_COLS; cc++) {
          if ((rr !== r || cc !== c) && board[rr][cc].value === val) {
            board[r][c].isError = true
            board[rr][cc].isError = true
          }
        }
      }
    }
  }
}

export function checkWin(board: Cell[][]): boolean {
  for (let r: number = 0; r < SIZE; r++) {
    for (let c: number = 0; c < SIZE; c++) {
      if (board[r][c].value === 0) {
        return false
      }
      if (board[r][c].isError) {
        return false
      }
    }
  }
  return true
}
