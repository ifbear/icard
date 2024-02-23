import Organize, { ORGANIZE_MODELS } from '../Models'

@CustomDialog
export struct OrganizeDialog {
  controller?: CustomDialogController

  selectHandler?: (val: string) => void

  private allOrganize = ORGANIZE_MODELS

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
                Image(item.major_image)
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