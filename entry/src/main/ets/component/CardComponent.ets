import router from '@ohos.router'
import { Card } from '../Card'
import { SubtitleComponent } from './SubtitleComponent'
import { SheetItem, SheetDialog } from './SheetDialog'

@Component
export struct CardComponent {
  item: Card
  radius: Length
  @State isReverse: boolean = false
  sheetController: CustomDialogController = new CustomDialogController({
    builder: SheetDialog({
      items: [
        new SheetItem('编辑', () => {
          this.edit()
        }, Color.Black, 18.0),
        new SheetItem('删除', () => {
          this.delete()
        }, Color.Red, 18.0)
      ]
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  })

  edit() {
    router.pushUrl({ url: "pages/Edit", params: this.item })
  }

  delete() {
    console.log("删除")
  }

  build() {
    Stack() {
      // 背景图1
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.End }) {
          Image($r('app.media.cardBg0'))
            .width('100%')
            .borderRadius({ bottomLeft: this.radius, bottomRight: this.radius })
        }
      }
      .width('100%')
      .height('100%')

      // 背景图2
      Column() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
          Image($r('app.media.btnCircleBg0'))
            .width('40%')
            .borderRadius({ topRight: this.radius })
        }
      }
      .width('100%')
      .height('100%')

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        // 卡号
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          SubtitleComponent({
            title: this.item.name,
            titleColor: Color.White,
            titleSize: 24.0,
            subtitle: this.item.card_no,
            subtitleColor: Color.White,
            subtitleSize: 28.0
          })
          if (this.isReverse === true) {
            Image($r('app.media.moreBtn'))
              .width(44)
              .onClick(() => {
                this.sheetController.open()
              })
          } else {
            Image($r('app.media.PaidBtn'))
              .width(44)
          }
        }
        .width('100%')
        .height('50%')
        .padding(16)

        if (this.isReverse === false) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            SubtitleComponent({
              title: '账单日',
              titleColor: Color.Orange,
              titleSize: 16.0,
              subtitle: '' + this.item.billday,
              subtitleSize: 28.0,
              subtitleColor: Color.White,
              subtitleWeight: FontWeight.Regular
            })
              .width('50%')
            SubtitleComponent({
              title: '还款日',
              titleColor: Color.Orange,
              titleSize: 16.0,
              subtitle: '' + this.item.paydate,
              subtitleSize: 28.0,
              subtitleColor: Color.White,
              subtitleWeight: FontWeight.Regular
            })
              .width('50%')
          }
          .width('100%')
          .height('50%')
          .padding(16)
        } else {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            SubtitleComponent({
              title: '有效期',
              titleColor: Color.Orange,
              titleSize: 16.0,
              subtitle: this.item.deadline,
              subtitleSize: 28.0,
              subtitleColor: Color.White,
              subtitleWeight: FontWeight.Regular
            })
            Image($r('app.media.iconChinaUnionPay'))
              .width(80)
          }
          .width('100%')
          .height('50%')
          .padding(16)
        }
      }
    }
    .backgroundColor('#895925')
    .width('100%')
    .borderRadius(this.radius)
    .onClick(() => {
      this.isReverse = !this.isReverse;
    })
  }
}