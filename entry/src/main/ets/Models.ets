import resourceManager from '@ohos.resourceManager';
/* 组织 */
export default class Organize {
  /* 名称 */
  name?: string
  /* t图片 */
  major_image?: Resource
  /* 白色 */
  white_image?: Resource

  constructor(name?: string, major_image?: Resource, white_image?: Resource) {
    this.name = name;
    this.major_image = major_image;
    this.white_image = white_image
  }
}

// 组织
export const ORGANIZE_MODELS: Organize[] = [
  new Organize('美国运通',$r('app.media.iconAmericanExpress'),$r("app.media.iconAmericanExpress_white")),
  new Organize('威士国际',$r('app.media.iconVisa'),$r("app.media.iconVisa_white")),
  new Organize('万事达',$r('app.media.iconMasterCard'),$r("app.media.iconMasterCard_white")),
  new Organize('中国银联',$r('app.media.iconChinaUnionPay'),$r("app.media.iconChinaUnionPay_white")),
  new Organize('大来信用',$r('app.media.iconDinersClub'),$r("app.media.iconDinersClub_white")),
  new Organize('日本国际',$r('app.media.iconJCB'),$r("app.media.iconJCB_white")),
  new Organize('蚂蚁金服',$r('app.media.iconAnt'),$r("app.media.iconAnt_white")),
  new Organize('其他组织',$r('app.media.iconOther'),$r("app.media.iconOther_white"))
]

/* 发行者 */
export class Issuer {
  id?: string
  /* 名称 */
  name?: string
  /* 更新时间 */
  update?: Date

  constructor() {
    this.id = undefined;
    this.name = undefined;
    this.update = undefined;
  }
}

/* 卡片 */
export class Card {
  id?: string
  /* 卡号 */
  card_no?: string
  /* 发行者 */
  issuer?: string
  /* 账单日 */
  billday?: string
  /* 还款日 */
  payday?: string
  /* 组织 */
  organize?: string
  /* 过期时间 */
  deadline?: string
  /* 备注 */
  remark?: string
  /* 更新时间 */
  update?: Date

  constructor() {
    this.id = undefined;
    this.card_no = undefined;
    this.issuer = undefined;
    this.billday = undefined;
    this.payday = undefined;
    this.organize = undefined;
    this.deadline = undefined;
    this.remark = undefined;
    this.update = undefined;
  }
}