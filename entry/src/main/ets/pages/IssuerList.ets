import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import buffer from '@ohos.buffer';
import { Issuer } from '../Models';
import router from '@ohos.router';
import { IssuerAddDialog } from '../component/IssuerAddDialog';

@Entry
@Component
export struct IssuerBank {
  agcDataBase: Database
  @State allIssuers: Issuer[] = []
  @State selectedIssuer?: Issuer = undefined
  // 添加发行者
  issuerDialog = new CustomDialogController({
    builder: IssuerAddDialog({
      cancel: () => {
        console.log("关闭了")
      },
      confirm: async (val) => {
        try {
          const issuer = new Issuer()
          issuer.id = new Date().getTime().toString()
          issuer.name = val
          issuer.update = new Date()
          await this.agcDataBase
            .collection(Issuer)
            .upsert(issuer)
          this.getAllIssuer()
        } catch (err) {
          console.log(JSON.stringify(err), "错误")
        }
      }
    }),
    alignment: DialogAlignment.Center
  })

  async onPageShow() {
    this.getAllIssuer()
  }

  aboutToDisappear() {
    this.issuerDialog = null
  }

  // database
  async getDatabase() {
    if (this.agcDataBase != null && this.agcDataBase != undefined) {
      return;
    }
    const context = getContext(this)
    const value = await context.resourceManager.getRawFileContent('schema.json');
    let json: string = buffer.from(value).toString("utf8");
    let info: ObjectTypeInfo = JSON.parse(json);
    this.agcDataBase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
  }

  // 获取issuer
  async getAllIssuer() {
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

  @Builder
  navigationMenus() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Image($r('app.media.secondListAdd'))
        .width(24)
        .margin({ right: 8 })
        .onClick(() => {
          this.issuerDialog.open()
        })

      Text('完成')
        .fontSize(18)
        .fontColor(this.selectedIssuer ? $r('app.color.major') : Color.Gray)
        .onClick(() => {
          if (this.selectedIssuer != null && this.selectedIssuer != undefined) {
            router.back({ url: "pages/ModifyCard", params: { 'issuer': this.selectedIssuer } })
          }
        })
    }
  }

  build() {
    Column() {
      Row() {
        RelativeContainer() {
          Image($r('app.media.closeIcon'))
            .id('close')
            .width(18)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
            .onClick(() => {
              router.back()
            })

          Text('选择发行者')
            .id('title')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })

          Image($r('app.media.secondListAdd'))
            .id('add')
            .width(18)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              right: { anchor: 'complete', align: HorizontalAlign.Start }
            })
            .onClick(() => {
              this.issuerDialog.open()
            })

          Text('完成')
            .id('complete')
            .fontWeight(FontWeight.Medium)
            .fontColor(this.selectedIssuer ? $r('app.color.major') : Color.Gray)
            .fontSize(16)
            .margin({ left: 8 })
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .onClick(async () => {
              if (this.selectedIssuer != null && this.selectedIssuer != undefined) {
                router.back({ url: "pages/ModifyCard", params: { 'issuer': this.selectedIssuer } })
              }
            })

        }
        .width('100%')
        .height('100%')
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height(44)
      .backgroundColor(Color.White)

      Column() {
        List({ space: 16 }) {
          ForEach(this.allIssuers, (item: Issuer) => {
            ListItem() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text(item.name)
                  .fontColor(Color.Black)
                  .fontSize(18)
                  .backgroundColor(Color.White)
                  .borderRadius(12)
                if (this.selectedIssuer != undefined && this.selectedIssuer.id === item.id) {
                  Image($r('app.media.checkmarkIcon'))
                    .width(24.0)
                } else {
                  Image('')
                }
              }
              .width('100%')
              .height('100%')
            }
            .borderRadius(8)
            .height(54)
            .backgroundColor(Color.White)
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.selectedIssuer = item
            })

          })
        }
        .padding(16)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.groupBackground'))
    }
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