import resourceManager from '@ohos.resourceManager';
/* 组织 */
export class Organize {
  id?: string
  /* 名称 */
  name?: string
  /* t图片 */
  image?: string
  /* 更新时间 */
  update?: Date

  constructor() {
    this.id = undefined;
    this.name = undefined;
    this.image = undefined;
    this.update = undefined;
  }
}

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