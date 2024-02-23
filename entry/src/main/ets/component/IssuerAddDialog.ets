@CustomDialog
export struct IssuerAddDialog {
  controller?: CustomDialogController
  @State issuer?: string = undefined

  cancel?: () => void
  confirm?: (val: string) => void

  build() {
    Column() {
      Text('添加发行者')
        .textAlign(TextAlign.Center)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      TextInput({})
        .margin({ top: 20 })
        .height(52)
        .borderRadius(12)
        .textAlign(TextAlign.Center)
        .onChange((val) => {
          this.issuer = val
        })

      Row() {
        Text('取消')
          .width('50%')
          .height(54)
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })

        Text('确定')
          .fontSize(18)
          .width('50%')
          .height(54)
          .backgroundColor(this.issuer ? $r('app.color.major') : Color.Gray)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .borderRadius(8)
          .onClick(() => {
            this.controller.close()
            this.confirm(this.issuer)
          })
      }
      .margin({ top: 20 })
      .height(54)
    }
    .padding(16)
  }
}