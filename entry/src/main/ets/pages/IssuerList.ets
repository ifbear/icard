import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import buffer from '@ohos.buffer';
import { Issuer } from '../Models';
import router from '@ohos.router';

@Entry
@Component
export struct IssuerBank {

  agcDataBase: Database

  @State allIssuers: Issuer[] = []

  @State selectedIssuer?: Issuer = undefined

  async getDatabase() {
    if (this.agcDataBase != null && this.agcDataBase != undefined) { return; }
    const context = getContext(this)
    const value = await context.resourceManager.getRawFileContent('schema.json');
    let json: string = buffer.from(value).toString("utf8");
    let info: ObjectTypeInfo = JSON.parse(json);
    this.agcDataBase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
  }

  async onPageShow() {
    try {
      await this.getDatabase()
      const resultArray = await this.agcDataBase
        .collection(Issuer)
        .query()
        .orderByDesc("update")
        .limit(100, 0)
        .get();
      this.allIssuers = resultArray

    } catch (err) {
      console.log("query err------------", JSON.stringify(err));
    }

  }

  @Builder navigationMenus() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Image($r('app.media.secondListAdd'))
        .width(24)
        .margin({ right: 8 })

      Text('完成')
        .fontSize(18)
        .fontColor(this.selectedIssuer ? $r('app.color.major') : Color.Gray )
        .onClick(() => {
          if (this.selectedIssuer != null && this.selectedIssuer != undefined) {
            router.back({ url: "pages/Edit", params: { 'issuer': this.selectedIssuer } })
          }
        })
    }
  }

  build() {
    Navigation() {
      List({ space: 16 }) {
        ForEach(this.allIssuers, (item: Issuer) => {
          ListItem() {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text(item.name)
                .fontColor(Color.Black)
                .fontSize(18)
                .backgroundColor(Color.White)
                .borderRadius(12)

              Image(this.selectedIssuer ? $r('app.media.checkmarkIcon') : '')
                .width(24.0)
            }
            .width('100%')
            .height('100%')
          }
          .height(54)
          .backgroundColor(Color.White)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            this.selectedIssuer = item
          })

        })
      }
      .padding(16)
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.groupBackground'))
    }
    .hideBackButton(false)
    .title("选择发行者")
    .titleMode(NavigationTitleMode.Mini)
    .menus(this.navigationMenus())
    .height('100%')
  }

  /**
   * The transition animation from page to page.
   */
  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ duration: 200 })
      .slide(SlideEffect.Bottom)
      .opacity(0)
  }
}