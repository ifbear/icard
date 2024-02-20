
export class Card {
    id?: string = undefined;
    name?: string = "";
    card_no?: string = "";
    update?: Date = undefined;

    constructor() {
        this.id = undefined;
        this.name = "";
        this.card_no = "";
        this.update = undefined;
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
}