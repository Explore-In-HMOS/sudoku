import { SudokuColors } from '../utils/SudokuColors'

@Component
export struct TimerDisplay {
  @Prop elapsedSeconds: number = 0

  private formatTime(): string {
    const minutes: number = Math.floor(this.elapsedSeconds / 60)
    const seconds: number = this.elapsedSeconds % 60
    const mm: string = minutes < 10 ? `0${minutes}` : `${minutes}`
    const ss: string = seconds < 10 ? `0${seconds}` : `${seconds}`
    return `${mm}:${ss}`
  }

  build() {
    Text(this.formatTime())
      .fontSize(16)
      .fontWeight(FontWeight.Normal)
      .fontColor(SudokuColors.TIMER_TEXT)
      .letterSpacing(2)
  }
}
