import { NavigationService, Page } from '../services/NavigationService';
import { common } from '@kit.AbilityKit';
import GlobalContext from '../utils/GlobalContext';
import { LevelPage } from './LevelPage';
import { GamePage } from './GamePage';

@Entry
@Component
struct NavigationPage {
  navigationService: NavigationService = NavigationService.getInstance();

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === Page.LEVEL_PAGE) {
        LevelPage()
      } else if (name === Page.GAME_PAGE) {
        GamePage()
      }
    }
    .onBackPressed(() => {
      if (name === Page.LEVEL_PAGE) {
        this.terminateApp();
        return true;
      }
      return false;
    })
    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos)
      .onAppear(() => {
        this.navigationService.navigateTo(Page.LEVEL_PAGE);
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.routeMap)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
      .hideTitleBar(true)
      .width('100%')
      .height('100%')
  }

  private terminateApp() {
    const context = GlobalContext.getInstance().getCntx() as common.UIAbilityContext;
    if (context) {
      context.terminateSelf();
    }
  }
}
