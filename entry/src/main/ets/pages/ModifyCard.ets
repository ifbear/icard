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

@Entry
@Component
struct Edit {
  @State card?: Card = router.getParams()['card'] as Card
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
    if (this.agcDataBase != null && this.agcDataBase != undefined) { return; }
    const context = getContext(this)
    const value = await context.resourceManager.getRawFileContent('schema.json');
    let json: string = buffer.from(value).toString("utf8");
    let info: ObjectTypeInfo = JSON.parse(json);
    this.agcDataBase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
  }

  // 导航按钮
  @Builder navigationMenus() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End, alignItems: ItemAlign.Center}) {
      Text('保存')
        .fontSize(18)
        .fontColor($r('app.color.major'))
        .onClick( async () => {
          try {
            this.card.update = new Date()
            console.log(JSON.stringify(this.card), "数据")
            await (this.agcDataBase as Database)
              .collection(Card)
              .upsert(this.card)
            setTimeout(() => {
              router.back()
            }, 3000)
          } catch (error) {
            promptAction.showToast({ message: JSON.stringify(error), duration: 5000, bottom: '50%' })
          }
        })
    }
  }

  // 布局
  build() {
    Navigation() {
      Column() {
        TextInput({ placeholder: '卡号', text: this.card.card_no ?? '' })
          .maxLength(16)
          .height(52.0)
          .margin({ top: 20 })
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
      .width('100%')
      .height('100%')
      .padding(16.0)
      .backgroundColor('#EFEFEF')
    }
    .title("编辑")
    .backButtonIcon($r('app.media.closeIcon'))
    .hideBackButton(false)
    .titleMode(NavigationTitleMode.Mini)
    .menus(this.navigationMenus())
  }

  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .slide(SlideEffect.Bottom)
    PageTransitionExit({ duration: 200 })
      .slide(SlideEffect.Bottom)
      .opacity(0)
  }
}
