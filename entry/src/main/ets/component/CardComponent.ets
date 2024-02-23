import router from '@ohos.router'
import Organize, { Card, ORGANIZE_MODELS } from '../Models'
import { SubtitleComponent } from './SubtitleComponent'
import { SheetItem, SheetDialog } from './SheetDialog'

@Component
export struct CardComponent {
  item: Card
  radius: Length
  @State isReverse: boolean = false

  // 编辑
  edit() {
    router.pushUrl({ url: "pages/Edit", params: { 'card': this.item } })
  }

  // 删除
  delete() {
    console.log("删除")
  }

  getOrganizeImageResource(item: Card): Resource {
    let organize = ORGANIZE_MODELS.find(({ name }) => name === item.organize )
    if (organize) {
      return organize.white_image
    } else {
      return $r("app.media.iconOther_white")
    }
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
            title: this.item.issuer,
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
                const dialog = new CustomDialogController({
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
                dialog.open()
              })
          } else {
            Image($r('app.media.PaidBtn'))
              .width(44)
              .onClick(() => {
              })
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
              subtitle: this.item.billday,
              subtitleSize: 28.0,
              subtitleColor: Color.White,
              subtitleWeight: FontWeight.Regular
            })
              .width('50%')
            SubtitleComponent({
              title: '还款日',
              titleColor: Color.Orange,
              titleSize: 16.0,
              subtitle: this.item.payday,
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
            Image(this.getOrganizeImageResource(this.item))
              .width(120)
          }
          .width('100%')
          .height('50%')
          .padding(16)
        }
      }

    }
    .backgroundColor($r('app.color.major'))
    .width('100%')
    .borderRadius(this.radius)
    .onClick(() => {
      this.isReverse = !this.isReverse;
    })
  }
}