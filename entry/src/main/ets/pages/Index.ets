import cloud, { Database, ObjectTypeInfo } from '@hw-agconnect/cloud';
import buffer from '@ohos.buffer';
import { Card } from '../Card';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  agcDataBase: Database | undefined = undefined
  @State allCards: Card[] = []

  async aboutToAppear() {
    try {
      const info: ObjectTypeInfo = await this.loadObjectInfo()
      this.agcDataBase = cloud.database({objectTypeInfo: info, zoneName: "ICARD"})
      this.getCards()
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

  async getCards() {
    try {
      const resultArray = await (this.agcDataBase as Database)
        .collection(Card)
        .query()
        .orderByDesc("update")
        .limit(100, 0)
        .get();
      this.allCards = resultArray
      console.log("query success : " + JSON.stringify(resultArray));
    } catch (err) {
      console.log("query err------------", JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Navigation() {
        List({ space: 10 }) {
          ForEach(this.allCards, (item: Card, index: Number) => {
            ListItem() {
              Stack() {
                Column() {
                  // Image($r('app.media.cardBg0'))
                  //   .width('100%')
                  //   .alignRules({
                  //     bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                  //     right: { anchor: '__container__', align: HorizontalAlign.End },
                  //     left: { anchor: '__container__', align: HorizontalAlign.Start }
                  //   })
                  Image($r('app.media.btnCircleBg0'))
                    .width('50%')
                    .height('50%')
                    .alignRules({
                      top: { anchor: '__container__', align: VerticalAlign.Top },
                      right: { anchor: '__container__', align: HorizontalAlign.End }
                    })
                }
                .width('100%')
                .height('100%')
                Flex({ direction: FlexDirection.Row }) {
                  Text(item.name)
                    .fontWeight(FontWeight.Bold)
                    .fontSize(24)
                }
                .width('100%')
                .height(150)
                .borderRadius(8)
                .padding(10)
              }
              .height(150)
              .width('100%')
            }
          })
        }
        .padding(16)
      }
      .title("ICARD")
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(true)

    }
    .height('100%')
    .width('100%')
  }
}