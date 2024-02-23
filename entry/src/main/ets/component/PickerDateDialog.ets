@CustomDialog
export struct PickerDateDialog {
  controller?: CustomDialogController
  start?: Date = new Date('1970-01-01')
  end?: Date = new Date('2099-12-31')
  selected?: Date = new Date()
  selectHandler?: (value: DatePickerResult) => void
  // 当前选中的日期
  @State __selected?: DatePickerResult = undefined

  build() {
    Column() {
      RelativeContainer() {
        Text('选择有效期')
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .fontSize(18.0)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .id("title")
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })

        Text('确定')
          .fontWeight(FontWeight.Medium)
          .fontColor(this.__selected ? $r('app.color.major') : Color.Gray)
          .fontSize(18.0)
          .id('confirm')
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .onClick(() => {
            this.selectHandler(this.__selected)
          })
      }
      .height(44)
      .margin({ left: 10, right: 10 })
      .width('100%')

      DatePicker({
        start: this.start,
        end: this.end,
        selected: this.selected
      })
        .width('100%')
        .height('100%')
        .onChange((value: DatePickerResult) => {
          this.__selected = value
        })
    }
    .padding(16)
    .height(320)
  }
}