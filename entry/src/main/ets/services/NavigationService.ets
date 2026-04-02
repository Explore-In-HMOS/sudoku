@ObservedV2
export class NavigationService {
  static _instance: NavigationService;
  @Trace pageInfos: NavPathStack = new NavPathStack();
  @Trace pageList: PageModel[] = [];

  static getInstance() {
    if (!NavigationService._instance) {
      NavigationService._instance = new NavigationService();
    }

    return NavigationService._instance;
  }

  navigateTo(name: string) {
    this.pageInfos.pushPath({ name: name });
  }

  navigateToWithArgs(name: string, param: string) {
    this.pageInfos.pushPath({ name: name, param: param });
  }

  navigateToWithObjectArgs(name: string, param: object) {
    this.pageInfos.pushPath({ name: name, param: param });
  }

  back() {
    this.pageInfos.pop();
  }

  clearStackAndNavigate(name: string) {
    this.pageInfos.clear();
    this.pageInfos.pushPath({ name: name });
  }
}

export class PageModel {
  page: () => void;
  pageRoute: string = '';

  constructor(page: () => void, pageRoute: string) {
    this.page = page;
    this.pageRoute = pageRoute;
  }
}

export enum Page {
  GAME_PAGE = 'GamePage',
  LEVEL_PAGE = 'LevelPage'
}