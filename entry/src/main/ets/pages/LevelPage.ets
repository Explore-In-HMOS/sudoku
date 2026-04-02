import { Board, Level, LevelOption } from '../models/SudokuModel'
import { NavigationService, Page } from '../services/NavigationService';
import { SudokuColors } from '../utils/SudokuColors'

@Entry
@Component
export struct LevelPage {
  navigationService: NavigationService = NavigationService.getInstance();

  private levelOptions: LevelOption[] = [
    {
      level: Level.EASY,
      label: Level.EASY,
      emoji: '🟢',
      color: SudokuColors.EASY_TEXT
    },
    {
      level: Level.MEDIUM,
      label: Level.MEDIUM,
      emoji: '🟡',
      color: SudokuColors.MEDIUM_TEXT
    },
    {
      level: Level.HARD,
      label: Level.HARD,
      emoji: '🔴',
      color: SudokuColors.HARD_TEXT
    }
  ]

  private navigateToGame(level: Level): void {
    this.navigationService.navigateToWithArgs(
      Page.GAME_PAGE,
      level.toString()
    );
  }

  @Builder
  LevelButton(option: LevelOption) {
    Row() {
      Text(option.emoji)
        .fontSize(18)
        .margin({ right: 4 })

      Text(option.label)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(option.color)
        .letterSpacing(2)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius(16)
    .margin({ bottom: 4 })
    .onClick(() => {
      this.navigateToGame(option.level)
    })
  }

  build() {
    Column() {
      Column() {
        Text('SUDOKU')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
          .fontColor(SudokuColors.TEXT_PRIMARY)
          .letterSpacing(6)
          .margin({ bottom: 3 })

        Text(Board.SIX_X_SIX)
          .fontSize(16)
          .fontColor(SudokuColors.TEXT_DISABLED)
          .letterSpacing(3)
          .margin({ bottom: 6 })

        Column(){
          ForEach(this.levelOptions, (option: LevelOption) => {
            this.LevelButton(option)
          }, (option: LevelOption): string => option.level)
        }
        .alignItems(HorizontalAlign.Start)

      }
      .width('80%')
      .height('80%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .backgroundColor(SudokuColors.BG_PAGE)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
