import { uiObserver } from '@kit.ArkUI'
import { SudokuBoard } from '../components/SudokuBoard'
import { TimerDisplay } from '../components/TimerDisplay'
import { Cell, Level } from '../models/SudokuModel'
import { SudokuColors } from '../utils/SudokuColors'
import { NavigationService } from '../services/NavigationService'
import { GameViewModel } from '../viewmodel/GameViewModel'

@Entry
@Component
export struct GamePage {
  private vm: GameViewModel = new GameViewModel()
  private navService: NavigationService = NavigationService.getInstance()
  navDesInfo: uiObserver.NavDestinationInfo | undefined

  @State board: Cell[][] = []

  aboutToAppear(): void {
    this.vm.onBoardChanged = (board: Cell[][]): void => {
      this.board = board
    }

    this.navDesInfo = this.queryNavDestinationInfo()
    const raw = this.navDesInfo?.param
    const level: Level = raw ? raw.valueOf() as Level : Level.EASY
    this.vm.initGame(level)
  }

  aboutToDisappear(): void {
    this.vm.dispose()
  }

  @Builder
  HeaderBar() {
    Column({ space: 3 }) {
      Text(this.vm.level)
        .fontSize(10)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.vm.getLevelColor())
        .letterSpacing(1)
      TimerDisplay({ elapsedSeconds: this.vm.elapsedSeconds })
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  WinOverlay() {
      Column() {
        Stack() {
          Circle()
            .width('95%')
            .height('95%')
            .fill(SudokuColors.BG_PAGE)
            .stroke(SudokuColors.SUCCESS)
            .strokeWidth(2)

          Column() {
            Text('🏆')
              .fontSize(30)
              .margin({ bottom: 3 })

            Text($r('app.string.congs'))
              .fontSize(18)
              .fontWeight(FontWeight.Bolder)
              .fontColor(SudokuColors.SUCCESS)
              .fontFamily('monospace')
              .letterSpacing(3)
              .margin({ bottom: 3 })

            Text(`${this.vm.level}`)
              .fontSize(9)
              .fontColor(SudokuColors.TEXT_DISABLED)
              .fontFamily('monospace')
              .letterSpacing(1)
              .margin({ bottom: 3 })

            Text(this.vm.formatTime())
              .fontSize(22)
              .fontColor(SudokuColors.TEXT_PRIMARY)
              .fontFamily('monospace')
              .letterSpacing(2)
              .margin({ bottom: 4 })

            Text($r('app.string.play_again'))
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor(SudokuColors.INFO)
              .fontFamily('monospace')
              .letterSpacing(1)
              .padding({ left: 4, right: 4, top: 3, bottom: 3 })
              .borderRadius(16)
              .border({ width: 1.5, color: SudokuColors.BORDER_SELECTED })
              .margin({ bottom: 3 })
              .onClick(() => {
                this.vm.restartGame()
              })

            Text($r('app.string.menu'))
              .fontSize(10)
              .fontWeight(FontWeight.Medium)
              .fontColor(SudokuColors.TEXT_HINT)
              .fontFamily('monospace')
              .letterSpacing(1)
              .padding({ left: 4, right: 4, top: 3, bottom: 3 })
              .borderRadius(16)
              .border({ width: 1, color: SudokuColors.TEXT_HINT })
              .onClick(() => {
                this.vm.dispose()
                this.navService.back()
              })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width('80%')
        .height('80%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(SudokuColors.OVERLAY_BG)
      .position({ x: 0, y: 0 })
  }

  build() {
    Stack() {
      Column() {
        this.HeaderBar()

        SudokuBoard({
          board: $board,
          selectedRow: this.vm.selectedRow,
          selectedCol: this.vm.selectedCol,
          onCellTap: (row: number, col: number): void => {
            this.vm.onCellTap(row, col)
          }
        })
      }
      .padding({ top: 12 })
      .backgroundColor(SudokuColors.BG_PAGE)
      .width('100%')
      .height('100%')

      if (this.vm.showWinDialog) {
        this.WinOverlay()
      }
    }
    .width('100%')
    .height('100%')
    .focusable(true)
    .focusOnTouch(true)
    .defaultFocus(true)
    .onDigitalCrown((event: CrownEvent) => {
      this.vm.onCrownEvent(event)
    })
  }
}
