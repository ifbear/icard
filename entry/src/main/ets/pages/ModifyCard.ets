import router from '@ohos.router'
import { Card, Issuer } from '../Models'
import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import buffer from '@ohos.buffer';
import promptAction from '@ohos.promptAction';
import { SubtitleComponent } from '../component/SubtitleComponent'
import { DayDialog } from '../component/DayDialog'
import { IssuerBank } from './IssuerList'
import { OrganizeDialog } from '../component/OrganizeDialog';
import { PickerDateDialog } from '../component/PickerDateDialog';
import display from '@ohos.display';

@Entry
@Component
struct Edit {
  private window = display.getDefaultDisplaySync()
  @State card?: Card = undefined
  @State title?: string = undefined
  agcDataBase: Database | undefined = undefined
  organizeDialog = new CustomDialogController({
    builder: OrganizeDialog({
      selectHandler: (val) => {
        this.card.organize = val
      }
    }),
    alignment: DialogAlignment.Center
  })
  pickerDateDialog = new CustomDialogController({
    builder: PickerDateDialog({
      selected: this.card.deadline ? new Date(this.card.deadline) : new Date(),
      selectHandler: (value: DatePickerResult) => {
        const year = '' + value.year
        const mouth = '0' + (value.month + 1)
        const day = '0' + value.day
        this.card.deadline = year + '-' + mouth.substring(mouth.length - 2) + '-' + day.substring(day.length - 2)
      }
    }),
    alignment: DialogAlignment.Center
  })

  async aboutToAppear() {
    if (router.getParams().hasOwnProperty('card')) {
      this.card = router.getParams()['card'] as Card
    }
    if (router.getParams().hasOwnProperty('title')) {
      this.title = router.getParams()['title'] as string
    }
    await this.getDatabase()
  }

  aboutToDisappear() {
    this.organizeDialog = null
    this.pickerDateDialog = null
  }

  async onPageShow() {
    if (router.getParams().hasOwnProperty('issuer')) {
      const issuer = router.getParams()['issuer'] as Issuer
      this.card.issuer = issuer ? issuer.name : undefined
    }
  }

  async getDatabase() {
    if (this.agcDataBase != null && this.agcDataBase != undefined) {
      return;
    }
    const context = getContext(this)
    const value = await context.resourceManager.getRawFileContent('schema.json');
    let json: string = buffer.from(value).toString("utf8");
    let info: ObjectTypeInfo = JSON.parse(json);
    this.agcDataBase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
  }

  // 布局
  build() {
    Column() {
      Row() {
        RelativeContainer() {
          Image($r('app.media.closeIcon'))
            .id('close')
            .width(18)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
            .onClick(() => {
              router.back()
            })

          Text(this.title)
            .id('title')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })

          Text('完成')
            .id('complete')
            .fontWeight(FontWeight.Medium)
            .fontSize(16)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .onClick(async () => {
              try {
                if (this.card.id == undefined || this.card.id == null) {
                  this.card.id = new Date().getTime().toString()
                }
                this.card.update = new Date()
                if (this.card.card_no == null) {
                  promptAction.showToast({ message: '卡号不能为空', bottom: -500, duration: 3000 })
                  return
                }
                if (this.card.issuer == null) {
                  promptAction.showToast({ message: '发行者不能为空', bottom: -500, duration: 3000 })
                  return
                }
                if (this.card.billday == null) {
                  promptAction.showToast({ message: '账单日不能为空', bottom: -500, duration: 3000 })
                  return
                }
                if (this.card.payday == null) {
                  promptAction.showToast({ message: '还款日不能为空', bottom: -500, duration: 3000 })
                  return
                }
                await this.agcDataBase.collection(Card).upsert(this.card)
                setTimeout(() => {
                  router.back()
                }, 500)
              } catch (error) {
                promptAction.showToast({ message: '错误：'+JSON.stringify(error), bottom: -500, duration: 3000 })
              }
            })

        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      Column() {
        TextInput({ placeholder: '卡号', text: this.card.card_no ?? '' })
          .maxLength(16)
          .height(52.0)
          .placeholderColor(Color.Gray)
          .borderRadius(8.0)
          .backgroundColor(Color.White)
          .padding({ left: 8, right: 8 })
          .onChange((val: string) => {
            this.card.card_no = val
          })

        Text(this.card.issuer ?? '选择发行者')
          .height(52.0)
          .margin({ top: 20 })
          .fontColor(this.card.issuer ? Color.Black : Color.Gray)
          .borderRadius(8.0)
          .backgroundColor(Color.White)
          .padding({ left: 8, right: 8 })
          .width('100%')
          .onClick(() => {
            router.pushUrl({
              url: "pages/IssuerList"
            })
          })

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          SubtitleComponent({
            title: '账单日',
            titleColor: '#999999',
            titleSize: 16.0,
            subtitle: this.card.billday ?? '',
            subtitleColor: Color.Black,
            subtitleSize: 32.0,
            subtitleAlign: TextAlign.Center
          })
            .padding(8.0)
            .height(80.0)
            .width('48%')
            .backgroundColor(Color.White)
            .borderRadius(8.0)
            .onClick(() => {
              const dialog = new CustomDialogController({
                builder: DayDialog({
                  title: "账单日",
                  selectHandler: (val: string) => {
                    this.card.billday = val
                    dialog.close()

                  }
                })
              })
              dialog.open()
            })

          SubtitleComponent({
            title: '还款日',
            titleColor: '#999999',
            titleSize: 16.0,
            subtitle: this.card.payday ?? '',
            subtitleColor: Color.Black,
            subtitleSize: 32.0,
            subtitleAlign: TextAlign.Center
          })
            .padding(8.0)
            .height(80.0)
            .width('48%')
            .backgroundColor(Color.White)
            .borderRadius(8.0)
            .backgroundColor(Color.White)
            .onClick(() => {
              const dialog = new CustomDialogController({
                builder: DayDialog({
                  title: "还款日",
                  selectHandler: (val: string) => {
                    this.card.payday = val
                    dialog.close()
                  }
                })
              })
              dialog.open()
            })
        }
        .margin({ top: 20 })

        Text(this.card.organize ?? "选择组织（可选）")
          .padding({ left: 8, right: 8 })
          .width('100%')
          .height(52.0)
          .margin({ top: 20 })
          .borderRadius(8.0)
          .backgroundColor(Color.White)
          .fontColor(this.card.organize ? Color.Black : Color.Gray)
          .onClick(() => {
            this.organizeDialog.open()
          })

        Text(this.card.deadline ?? "选择有效期（可选）")
          .padding({ left: 8, right: 8 })
          .width('100%')
          .height(52.0)
          .margin({ top: 20 })
          .borderRadius(8.0)
          .backgroundColor(Color.White)
          .fontColor(this.card.deadline ? Color.Black : Color.Gray)
          .onClick(() => {
            this.pickerDateDialog.open()
          })

        TextInput({ placeholder: '备注内容', text: this.card.remark ?? '' })
          .maxLength(16)
          .height(52.0)
          .margin({ top: 20 })
          .placeholderColor(Color.Gray)
          .borderRadius(8.0)
          .backgroundColor(Color.White)
          .padding({ left: 8, right: 8 })
          .onChange((val: string) => {
            this.card.remark = val
          })
      }
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EFEFEF')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ duration: 200 })
      .slide(SlideEffect.Bottom)
      .opacity(0)
  }
}
