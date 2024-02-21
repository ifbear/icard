import router from '@ohos.router'
import { Card } from '../Card'
import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import buffer from '@ohos.buffer';
import promptAction from '@ohos.promptAction';
import { SubtitleComponent } from '../component/SubtitleComponent'
import { DayDialog } from '../component/DayDialog'

const enum DialogType {
  Bill = 1001,
  Paid = 1002
}

@Entry
@Component
struct Edit {

  @State item?: Card = router.getParams() as Card

  agcDataBase: Database | undefined = undefined
  dislogType?: DialogType
  dayDialogController = new CustomDialogController({
    builder: DayDialog({
      selectHandler: (val) => {
        switch (this.dislogType) {
          case DialogType.Bill:
            this.item.billday = val
            break
          case DialogType.Paid:
            this.item.paydate = val
            break
        }
      }
    })
  })

  async aboutToAppear() {
    try {
      const info: ObjectTypeInfo = await this.loadObjectInfo()
      this.agcDataBase = cloud.database({ objectTypeInfo: info, zoneName: "ICARD" })
    } catch (error) {
      console.log(JSON.stringify(error))
    }
  }

  loadObjectInfo(): Promise<ObjectTypeInfo> {
    return new Promise(async (resolve: Function) => {
      const context = getContext(this)
      const value = await context.resourceManager.getRawFileContent('schema.json');
      let json: string = buffer.from(value).toString("utf8");
      let objectTypeInfo: ObjectTypeInfo = JSON.parse(json);
      resolve(objectTypeInfo)
    })
  }

  build() {
    Navigation() {
      Column() {
        TextInput({ placeholder: '银行卡号', text: this.item.card_no })
          .maxLength(16)
          .onChange((val) => {
            this.item.card_no = val
          })
          .height(52.0)
          .margin({ top: 20 })
          .placeholderColor(Color.Gray)
          .borderRadius(8.0)
          .backgroundColor(Color.White)

        TextInput({ placeholder: '发行银行', text: this.item.name })
          .onChange((val) => {
            this.item.name = val
          })
          .height(52.0)
          .margin({ top: 20 })
          .placeholderColor(Color.Gray)
          .borderRadius(8.0)
          .backgroundColor(Color.White)

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          SubtitleComponent({
            title: '账单日',
            titleColor: '#999999',
            titleSize: 16.0,
            subtitle: '' + this.item.billday,
            subtitleColor: Color.Black,
            subtitleSize: 32.0,
            subtitleAlign: TextAlign.Center
          })
            .onClick(() => {
              this.dislogType = DialogType.Bill
              this.dayDialogController.open()
            })
            .padding(8.0)
            .height(80.0)
            .width('48%')
            .backgroundColor(Color.White)
            .borderRadius(8.0)

          SubtitleComponent({
            title: '还款日',
            titleColor: '#999999',
            titleSize: 16.0,
            subtitle: '' + this.item.paydate,
            subtitleColor: Color.Black,
            subtitleSize: 32.0,
            subtitleAlign: TextAlign.Center
          })
            .onClick(() => {
              this.dislogType = DialogType.Paid
              this.dayDialogController.open()
            })
            .padding(8.0)
            .height(80.0)
            .width('48%')
            .backgroundColor(Color.White)
            .borderRadius(8.0)
            .backgroundColor(Color.White)
        }
        .margin({ top: 20 })

        TextInput({ placeholder: '过期时间', text: this.item.deadline })
          .width('100%')
          .height(52.0)
          .margin({ top: 20 })
          .borderRadius(8.0)
          .backgroundColor(Color.White)

      }
      .width('100%')
      .height('100%')
      .padding(16.0)
      .backgroundColor('#EFEFEF')
    }
    .title("编辑")
    .hideBackButton(false)
    .titleMode(NavigationTitleMode.Mini)
    .menus([
      { value: "", icon: '../../resources/base/media/editIcon.png', action: async () => {
        try {
          await (this.agcDataBase as Database)
            .collection(Card)
            .upsert(this.item)
          setTimeout(() => {
            router.back()
          }, 3000)
        } catch (error) {
          promptAction.showToast({ message: JSON.stringify(error), duration: 5000 })
        }
      } }
    ])
  }
}