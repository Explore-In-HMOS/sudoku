export enum Level {
  EASY = 'EASY',
  MEDIUM = 'MEDIUM',
  HARD = 'HARD'
}

export enum Board {
  FOUR_X_FOUR = '4 × 4',
  SIX_X_SIX = '6 × 6',
  NINE_X_NINE = '9 × 9',
  TWELVE_X_TWELVE = '12 × 12'
}

export interface LevelOption {
  level: Level
  label: string
  emoji: string
  color: string
}

@Observed
export class Cell {
  id: string
  row: number
  col: number
  value: number
  isFixed: boolean
  isError: boolean
  tapCount: number

  constructor(row: number, col: number, value: number = 0, isFixed: boolean = false) {
    this.id = `${row}_${col}`
    this.row = row
    this.col = col
    this.value = value
    this.isFixed = isFixed
    this.isError = false
    this.tapCount = isFixed ? value : 0
  }
}
