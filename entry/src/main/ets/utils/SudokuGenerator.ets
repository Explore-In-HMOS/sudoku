import { Cell, Level } from '../models/SudokuModel'
import { isValidPlacement, hasUniqueSolution } from './SudokuValidator'
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

const SIZE: number = 6

function secureRandomInt(rand: cryptoFramework.Random, max: number): number {
  if (max <= 1) {
    return 0
  }
  const randData: cryptoFramework.DataBlob = rand.generateRandomSync(4)
  const bytes: Uint8Array = randData.data
  const value: number =
    ((bytes[0] & 0xFF) << 24) |
      ((bytes[1] & 0xFF) << 16) |
      ((bytes[2] & 0xFF) << 8) |
      (bytes[3] & 0xFF)
  return (value >>> 0) % max
}

function createEmptyRow(): number[] {
  return [0, 0, 0, 0, 0, 0]
}

function createEmptyGrid(): number[][] {
  return [
    createEmptyRow(), createEmptyRow(), createEmptyRow(),
    createEmptyRow(), createEmptyRow(), createEmptyRow()
  ]
}

function copyRow(srcRow: number[]): number[] {
  return [srcRow[0], srcRow[1], srcRow[2], srcRow[3], srcRow[4], srcRow[5]]
}

function copyGrid(grid: number[][]): number[][] {
  return [
    copyRow(grid[0]), copyRow(grid[1]), copyRow(grid[2]),
    copyRow(grid[3]), copyRow(grid[4]), copyRow(grid[5])
  ]
}

function shuffleArray(rand: cryptoFramework.Random, arr: number[]): void {
  for (let i: number = arr.length - 1; i > 0; i--) {
    const j: number = secureRandomInt(rand, i + 1)
    const temp: number = arr[i]
    arr[i] = arr[j]
    arr[j] = temp
  }
}

function getShuffledValues(rand: cryptoFramework.Random): number[] {
  const values: number[] = [1, 2, 3, 4, 5, 6]
  shuffleArray(rand, values)
  return values
}

function fillGrid(rand: cryptoFramework.Random, grid: number[][]): boolean {
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
    return true
  }

  const values: number[] = getShuffledValues(rand)
  for (let i: number = 0; i < values.length; i++) {
    const val: number = values[i]
    if (isValidPlacement(grid, emptyRow, emptyCol, val)) {
      grid[emptyRow][emptyCol] = val
      if (fillGrid(rand, grid)) {
        return true
      }
      grid[emptyRow][emptyCol] = 0
    }
  }

  return false
}

function generateSolution(rand: cryptoFramework.Random): number[][] {
  const grid: number[][] = createEmptyGrid()
  fillGrid(rand, grid)
  return grid
}

function getEmptyCellCount(rand: cryptoFramework.Random, level: Level): number {
  switch (level) {
    case Level.EASY:
      return 18 + secureRandomInt(rand, 3)
    case Level.MEDIUM:
      return 20 + secureRandomInt(rand, 3)
    case Level.HARD:
      return 26 + secureRandomInt(rand, 3)
    default:
      return 16
  }
}

function buildPositions(): number[] {
  const positions: number[] = []
  for (let i: number = 0; i < SIZE * SIZE; i++) {
    positions.push(i)
  }
  return positions
}

function createPuzzle(rand: cryptoFramework.Random, solution: number[][], level: Level): number[][] {
  const puzzle: number[][] = copyGrid(solution)
  const targetEmpty: number = getEmptyCellCount(rand, level)
  const positions: number[] = buildPositions()
  shuffleArray(rand, positions)

  let removedCount: number = 0

  for (let i: number = 0; i < positions.length; i++) {
    if (removedCount >= targetEmpty) {
      break
    }

    const pos: number = positions[i]
    const row: number = Math.floor(pos / SIZE)
    const col: number = pos % SIZE

    if (puzzle[row][col] === 0) {
      continue
    }

    const backup: number = puzzle[row][col]
    puzzle[row][col] = 0

    if (hasUniqueSolution(puzzle)) {
      removedCount++
    } else {
      puzzle[row][col] = backup
    }
  }

  return puzzle
}

function buildRow(puzzle: number[][], row: number): Cell[] {
  const rowCells: Cell[] = []
  for (let col: number = 0; col < SIZE; col++) {
    const clueValue: number = puzzle[row][col]
    const isFixed: boolean = clueValue !== 0
    const cell: Cell = new Cell(row, col, clueValue, isFixed)
    rowCells.push(cell)
  }
  return rowCells
}

export function generateBoard(level: Level): Cell[][] {
  const rand: cryptoFramework.Random = cryptoFramework.createRandom()
  const solution: number[][] = generateSolution(rand)
  const puzzle: number[][] = createPuzzle(rand, solution, level)

  const board: Cell[][] = []
  for (let row: number = 0; row < SIZE; row++) {
    board.push(buildRow(puzzle, row))
  }

  return board
}
