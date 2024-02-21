@CustomDialog
export struct DayDialog {
  controller?: CustomDialogController
  private days: Array<number> = new Array()

  selectHandler?: (day: number) => void

  aboutToAppear() {
    for(let i = 1; i < 32; i++) {
      this.days.push(i)
    }
  }

  build() {
      Grid() {
        ForEach(this.days, (day) => {
          GridItem() {
            Text( ''+ day)
              .width('100%')
              .height('100%')
              .textAlign(TextAlign.Center)
              .fontSize(24.0)
              .fontColor(Color.Black)
              .backgroundColor(Color.White)
              .clip(new Circle({ width: '100%', height: '100%' }))
              .onClick(() => {
                this.selectHandler(day)
                this.controller.close()
              })
          }
        })
      }
      .rowsGap(10)
      .columnsGap(10)
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .backgroundColor('#EFEFEF')
      .padding(10)
    }

}