@Component
export struct SubtitleComponent {
  @Prop title: string
  titleColor?: ResourceColor
  titleWeight?: number | FontWeight | string
  titleSize?: number | string | Resource
  titleAlign?: TextAlign

  @Prop subtitle: string
  subtitleColor?: ResourceColor
  subtitleWeight?: number | FontWeight | string
  subtitleSize?: number | string | Resource
  subtitleAlign?: TextAlign

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      Text(this.title ?? '')
        .fontWeight(this.titleWeight)
        .fontSize(this.titleSize)
        .fontColor(this.titleColor)
        .textAlign(this.titleAlign)
        .width('100%')

      Text(this.subtitle ?? '')
        .fontWeight(this.subtitleWeight)
        .fontSize(this.subtitleSize)
        .padding({ top: 10 })
        .fontColor(this.subtitleColor)
        .textAlign(this.subtitleAlign)
        .width('100%')
    }
  }
}