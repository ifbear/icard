export class SheetItem {
  title?: string
  event?: (event?: ClickEvent) => void
  fontColor?: ResourceColor
  fontSize?: number | string | Resource

  constructor(title?: string, event?: (event?: ClickEvent) => void, fontColor?: ResourceColor, fontSize?: number | string | Resource ) {
    this.title = title
    this.event = event
    this.fontColor = fontColor
    this.fontSize = fontSize
  }
}

@CustomDialog
export struct SheetDialog {
  controller?: CustomDialogController

  items: SheetItem[]

  getHeight() {
    return this.items.length * 52.0 + 32.0
  }

  build() {
    Column() {
      ForEach(this.items, (item: SheetItem) => {
        Row() {
          Text(item.title)
            .fontColor(item.fontColor)
            .fontSize(item.fontSize)
            .height(44)
            .onClick(item.event)
        }
      })
    }
    .padding(16.0)
    .height(this.getHeight())
  }
}
