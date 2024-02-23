import { Card } from '../Models';
import { CardComponent } from '../component/CardComponent';
import router from '@ohos.router';
import buffer from '@ohos.buffer';
import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State allCards: Card[] = []
  agcDatabase: Database

  /* 页面展示 */
  async onPageShow() {
    await this.getDatabase()
    await this.getAllCard()
  }

  async getDatabase() {
    resourceManager
    if (this.agcDatabase != null && this.agcDatabase != undefined) { return; }
    try {
      const context = getContext(this)
      const value = await context.resourceManager.getRawFileContent('schema.json');
      let json: string = buffer.from(value).toString("utf8");
      let info: ObjectTypeInfo = JSON.parse(json);
      this.agcDatabase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
    } catch (err) {
      console.log("错误", JSON.stringify(err))
    }
  }

  async getAllCard() {
    try {
      const resultArray = await this.agcDatabase
        .collection(Card)
        .query()
        .orderByDesc("update")
        .limit(100, 0)
        .get();
      this.allCards = resultArray
    } catch (err) {
      console.log("query err------------", JSON.stringify(err));
    }
  }

  /* 导航menus */
  @Builder navigationMenus() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Image($r('app.media.Add'))
        .width(24)
        .height(24)
        .onClick(() => {
          const item = new Card()
          item.id = new Date().getTime().toString()
          router.pushUrl({ url: 'pages/ModifyCard', params: { 'card' : item } })
        })
    }
  }

  // 页面布局
  build() {
    Column() {
      Navigation() {
        List({ space: 10 }) {
          ForEach(this.allCards, (item: Card) => {
            ListItem() {
              CardComponent({ item: item, radius: 16.0 })
                .height(240)
            }
          })
        }
        .padding(16)
      }
      .title("")
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(true)
      .menus(this.navigationMenus())
    }
    .height('100%')
    .width('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ duration: 200 })
      .slide(SlideEffect.Top)
      .opacity(0)
  }
}