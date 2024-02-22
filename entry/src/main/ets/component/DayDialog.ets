@CustomDialog
export struct DayDialog {
  controller?: CustomDialogController
  private days: Array<string> = new Array()
  selectHandler?: (day: string) => void
  title?: string = ""

  aboutToAppear() {
    for (let i = 1; i < 32; i++) {
      this.days.push(i + '')
    }
  }

  build() {
    Grid() {
      GridItem() {
        Text(this.title)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(24.0)
          .margin({ top: 10, bottom: 20 })
      }
      .columnStart(1)
      .columnEnd(4)

      ForEach(this.days, (day) => {
        GridItem() {
          Text('' + day)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
            .fontSize(24.0)
            .fontColor(Color.Black)
            .backgroundColor(Color.White)
            .clip(new Circle({ width: '100%', height: '100%' }))
            .onClick(() => {
              this.selectHandler(day)
            })
        }
        .width('100%')
        .height('12%')
      })
    }
    .rowsGap(10)
    .columnsGap(10)
    // .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .padding(10)
    .backgroundColor('#EFEFEF')
  }
}