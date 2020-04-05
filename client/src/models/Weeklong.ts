
export default class Weeklong {
  private id: number;
  private title: string;
  private startDate: Date;
  private endDate: Date;
  private state: number;
  private waiver: string;
  private stunTimer: number;
  // private details:  WeeklongDetails;
  // private players: Array<Player>;
  // private activity: Array<Player>;
  private static activeGame: Weeklong;

  constructor(data: any){
    this.id = data["id"];
    this.title = data["title"];
    this.startDate = new Date(data["start_date"]);
    this.endDate = new Date(data["end_date"]);
    this.state = data["state"];
    this.waiver = data["waiver"];
    this.stunTimer = data["stun_timer"];
    // this.details = new Array<Player>;
    // this.players = new Array<Player>();
    // this.activity = new Array<Activity>();
  }
  //
  // getID(){
  //   return this.id;
  // }
  //
  // getTitle(){
  //   return this.title;
  // }
  //
  // getStartDate(){
  //   return this.startDate;
  // }
  //
  // getEndDate(){
  //   return this.endDate;
  // }
  //
  // getWaiver(){
  //   return this.waiver;
  // }
  //
  // getState(){
  //   return this.state;
  // }
  //
  // // getStunTimer()
  // // getDetails()
  // // getPlayers()
  // // getActivity()
  // // getActiveWeeklong()
  // setTitle(title){
  //   this.title = title;
  // }
  //
  // setStartDate(date){
  //   this.startDate = date;
  // }
  //
  // setEndDate(date){
  //   this.endDate = date;
  // }
  //
  // setWaiver(waiver){
  //   this.waiver = waiver;
  // }
  // setStunTimer(time)
  // setDetails(details)
  // setPlayers(players[])
  // addPlayer(player)
  // setActivity(activity[])
  // addActivity(activity)
  // setActiveWeeklong()
}
