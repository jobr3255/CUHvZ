
export default class Lockin {
  private id: number;
  private title: string;
  private eventDate: string;
  private waiver: string;
  private eventbrite: string;
  private blasterEventbrite: string;
  private state: number;
  private details: string;

  constructor(data: any) {
    this.id = data["id"];
    this.title = data["title"];
    this.eventDate = data["event_date"];
    this.waiver = data["waiver"];
    this.eventbrite = data["eventbrite"];
    this.blasterEventbrite = data["blaster_eventbrite"];
    this.state = data["state"];
    this.details = data["details"];
  }

  /***************
      GETTERS
   ***************/

  getID(): number {
    return this.id;
  }

  getTitle(): string {
    return this.title;
  }

  getEventDate(): string {
    return this.eventDate;
  }

  getWaiver(): string {
    return this.waiver;
  }

  getEventbrite(): string {
    return this.eventbrite;
  }

  getBlasterEventbrite(): string {
    return this.blasterEventbrite;
  }

  getState(): number {
    return this.state;
  }

  getDetails(): string {
    return this.details;
  }

  /***************
      SETTERS
   ***************/

  setTitle(title: string) {
    this.title = title;
  }

  setEventDate(date: string) {
    this.eventDate = date;
  }

  setWaiver(waiver: string) {
    this.waiver = waiver;
  }

  setEventbrite(link: string) {
    this.eventbrite = link;
  }

  setBlasterEventbrite(link: string) {
    this.blasterEventbrite = link;
  }

  setState(state: number) {
    this.state = state;
  }

  setDetails(details: string) {
    this.details = details;
  }
}
