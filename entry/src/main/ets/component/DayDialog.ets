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
    Column() {
      Row() {
        Text(this.title)
          .textAlign(TextAlign.Center)
          .fontSize(18.0)
          .fontWeight(FontWeight.Medium)
          .width('100%')
      }
      .height('10%')
      .width('100%')
      Row() {
        Grid() {
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
      .height('90%')
      .width('100%')

    }
    .width('100%')
  }
}