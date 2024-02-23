
class Organize {
  name: string
  image: Resource

  constructor(name: string, image: Resource) {
    this.name = name
    this.image = image
  }
}

@CustomDialog
export struct OrganizeDialog {
  controller?: CustomDialogController

  selectHandler?: (val: string) => void

  private allOrganize: Organize[] = [
    new Organize('美国运通',$r('app.media.iconAmericanExpress')),
    new Organize('威士国际',$r('app.media.iconVisa')),
    new Organize('万事达',$r('app.media.iconMasterCard')),
    new Organize('中国银联',$r('app.media.iconChinaUnionPay')),
    new Organize('大来信用',$r('app.media.iconDinersClub')),
    new Organize('日本国际',$r('app.media.iconJCB')),
    new Organize('蚂蚁金服',$r('app.media.iconAnt')),
    new Organize('其他组织',$r('app.media.iconOther'))
  ]

  /* 页面展示 */
  async aboutToAppear() {
  }

  build() {
    Column() {
      Row() {
        Text('选择组织')
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
      }
      .height('8%')

      Row() {
        Grid() {
          ForEach(this.allOrganize, (item: Organize) => {
            GridItem() {
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Image(item.image)
                  .objectFit(ImageFit.ScaleDown)
                  .height(80)
                  .borderRadius(8)

                Text(item.name)
                  .fontSize(18)
                  .fontColor(Color.Black)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
            }
            .backgroundColor(Color.White)
            .padding(10)
            .borderRadius(8)
            .onClick(() => {
              this.controller.close()
              this.selectHandler(item.name)
            })
          })
        }
        .columnsTemplate('1fr 1fr')
        .width('100%')
        .height('100%')
        .rowsGap(20)
        .columnsGap(20)
        .padding(20)
      }
      .height('92%')
      .backgroundColor($r('app.color.groupBackground'))
    }
    .width('100%')
    .height('100%')
  }
}