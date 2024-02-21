
export class Card {

    id?: string = undefined;
    /* 名称 */
    name?: string = "";
    /* 卡号 */
    card_no?: string = "";
    /* 更新时间 */
    update?: Date = undefined;
    /* 过期时间 */
    deadline?: string = undefined;
    /* 账单日 */
    billday?: number = undefined;
    /* 还款日 */
    paydate?: number = undefined;

    constructor() {
        this.id = undefined;
        this.name = "";
        this.card_no = "";
        this.update = undefined;
        this.deadline = undefined;
        this.billday = undefined;
        this.paydate = undefined;
    }

    setId(id) {
        this.id = id;
    }

    getId() {
        return this.id;
    }

    setName(name) {
        this.name = name;
    }

    getName() {
        return this.name;
    }

    setCard_no(card_no) {
        this.card_no = card_no;
    }

    getCard_no() {
        return this.card_no;
    }

    setUpdate(update) {
        this.update = update;
    }

    getUpdate() {
        return this.update;
    }

    setDeadline(deadline) {
        this.deadline = deadline;
    }

    getDeadline() {
        return this.deadline;
    }

    setBillday(billday) {
        this.billday = billday;
    }

    getBillday() {
        return this.billday;
    }

    setPaydate(paydate) {
        this.paydate = paydate;
    }

    getPaydate() {
        return this.paydate;
    }
}