import { Card } from '../Models';
import { CardComponent, CardEvent } from '../component/CardComponent';
import router from '@ohos.router';
import buffer from '@ohos.buffer';
import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import resourceManager from '@ohos.resourceManager';
import promptAction from '@ohos.promptAction';

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
    if (this.agcDatabase != null && this.agcDatabase != undefined) {
      return;
    }
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

  // 页面布局
  build() {
    Column() {
      Row() {
        RelativeContainer() {
          Text('iCard')
            .id('title')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })

          Image($r('app.media.Add'))
            .id('add')
            .width(24)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/ModifyCard',
                params: { 'card': new Card(), 'title': '添加信用卡' }
              })
            })
        }
        .width('100%')
        .height('100%')
      }
      .padding({ left: 16, right:16 })
      .height(44)

      List({ space: 10 }) {
        ForEach(this.allCards, (item: Card) => {
          ListItem() {
            CardComponent({
              item: item,
              radius: 16.0,
              actionHandler: async (event: CardEvent, item: Card) => {
                switch (event) {
                  case CardEvent.Edit:
                    router.pushUrl({
                      url: "pages/Edit",
                      params: { 'card': item, 'title': '编辑信用卡' }
                    })
                    break
                  case CardEvent.Delete:
                    try {
                      await this.agcDatabase.collection(Card).delete(item)
                      this.getAllCard()
                    } catch (error) {
                      promptAction.showToast({ message: '错误:'+JSON.stringify(error), duration: 3000 })
                    }
                    break
                }
              }
            })
              .height(200)
          }
        })
      }
      .padding(16)
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