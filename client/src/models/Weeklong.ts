import WeeklongDetails from "./WeeklongDetails";

export default class Weeklong {
  private id: number;
  private title: string;
  private startDate: string;
  private endDate: string;
  private state: number;
  private waiver: string;
  private stunTimer: number;
  private details:  WeeklongDetails;
  // private players: Array<Player>;
  // private activity: Array<Player>;
  private static activeGame: Weeklong;

  constructor(data: any) {
    this.id = data["id"];
    this.title = data["title"];
    this.startDate = data["start_date"];
    this.endDate = data["end_date"];
    this.state = data["state"];
    this.waiver = data["waiver"];
    this.stunTimer = data["stun_timer"];
    this.details = new WeeklongDetails(data);
    // this.players = new Array<Player>();
    // this.activity = new Array<Activity>();
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

  getStartDate(): string {
    return this.startDate;
  }

  getEndDate(): string {
    return this.endDate;
  }

  getWaiver(): string {
    return this.waiver;
  }

  getState(): number {
    return this.state;
  }

  getStunTimer(): number {
    return this.stunTimer;
  }

  getDetails(): WeeklongDetails {
    return this.details;
  }

  // getPlayers()
  // getActivity()
  
  static getActiveWeeklong(): Weeklong{
    return Weeklong.activeGame;
  }

  /***************
      SETTERS
   ***************/

  setTitle(title: string) {
    this.title = title;
  }

  setStartDate(date: string) {
    this.startDate = date;
  }

  setEndDate(date: string) {
    this.endDate = date;
  }

  setWaiver(waiver: string) {
    this.waiver = waiver;
  }
  setStunTimer(time: number) {
    this.stunTimer = time;
  }

  setDetails(details: WeeklongDetails) {
    this.details = details;
  }

  // setDetails(details)
  // setPlayers(players[])
  // addPlayer(player)
  // setActivity(activity[])
  // addActivity(activity)

  setActiveWeeklong(){
    Weeklong.activeGame = this;
  }
}
