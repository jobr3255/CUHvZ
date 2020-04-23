import User from "./User";

export default class Player extends User{
  private playerID: number;
  private weeklongID: number;
  private type: string;
  private poisoned: number;
  private playerCode: string;
  private points: number;
  private kills: number;
  protected starveDate: string;
  private eventEndDate: string;

  constructor(data: any) {
    super(data);
    this.playerID = data["id"];
    this.id = data["user_id"];
    this.weeklongID = data["weeklong_id"];
    this.username = data["username"];
    this.type = data["type"];
    this.poisoned = data["poisoned"];
    this.playerCode = data["player_code"];
    this.points = data["points"];
    this.kills = data["kills"];
    this.starveDate = data["starve_date"];
    this.eventEndDate = data["end_date"];
  }

  public getStarveTimer(): string {
    var starveDate = new Date(this.starveDate);
    var endDate = new Date(this.eventEndDate);
    var now = new Date();
    var timer: number;
    if(now.getTime() > endDate.getTime()){
      // Event has ended
      timer = starveDate.getTime() - endDate.getTime();
    }else{
      timer = starveDate.getTime() - now.getTime();
    }
    var minutes = Math.abs(Math.floor((timer / (1000 * 60)) % 60));
    var hours = Math.abs(Math.floor((timer / (1000 * 60 * 60)) % 24));
    var formatted = `${hours}:${minutes}`;
    if (minutes === 0)
      formatted = `${hours}:00`;
    else if (minutes < 10)
      formatted = `${hours}:0${minutes}`
    return formatted;
  }

  /***************
      GETTERS
   ***************/

  getUserID(): number {
    return this.id;
  }

  getWeeklongID(): number {
    return this.weeklongID;
  }

  getPlayerID(): number {
    return this.playerID;
  }

  getType(): string {
    return this.type;
  }

  getPoisoned(): number {
    return this.poisoned;
  }

  getPlayerCode(): string {
    return this.playerCode;
  }

  getPoints(): number {
    return this.points;
  }

  getKills(): number {
    return this.kills;
  }

  getStarveDate(): string {
    return this.starveDate;
  }

  /***************
      SETTERS
   ***************/

   setType(type: string) {
     this.type = type;
   }

   setPoisoned(poison: number) {
     this.poisoned = poison;
   }

   setPlayerCode(code: string) {
     this.playerCode = code;
   }

   setPoints(points: number) {
     this.points = points;
   }

   setKills(kills: number) {
     this.kills = kills;
   }

   setStarveDate(date: string) {
     this.starveDate = date;
   }
}

export class Human extends Player{
}

export class Zombie extends Player{
}

export class Deceased extends Player{
  getStarvedDate(): string {
    var starveDate = new Date(this.starveDate);
    var hours = starveDate.getHours();
    var minutes = starveDate.getMinutes();
    var dayNum = starveDate.getDay();
    var day = "";
    switch(dayNum){
      case 1 : day = "Mon"; break;
      case 2 : day = "Tue"; break;
      case 3 : day = "Wed"; break;
      case 4 : day = "Th"; break;
      case 5 : day = "Fri"; break;
      case 6 : day = "Sat"; break;
      case 7 : day = "Sun"; break;
    }
    var meridiem = "";
    if(hours >= 0 && hours < 12){
      meridiem = "am";
      if(hours === 0)
        hours = 12;
    }else if(hours >= 12){
      meridiem = "pm";
      if(hours > 12)
        hours -= 12;
    }
    var formatted = `${day} ${hours}:${minutes} ${meridiem}`;
    if (minutes === 0)
      formatted = `${day} ${hours}:00 ${meridiem}`;
    else if (minutes < 10)
      formatted = `${day} ${hours}:0${minutes} ${meridiem}`;
    return formatted;
  }

  getStarveTimer(): string {
    return "--:--";
  }
}
