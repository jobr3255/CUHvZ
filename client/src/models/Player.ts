import User from "./User";

export default class Player extends User{
  private playerID: number;
  private weeklongID: number;
  private status: string;
  private poisoned: number;
  private playerCode: string;
  private points: number;
  private kills: number;
  private starveDate: string;

  constructor(data: any) {
    super(data);
    this.playerID = data["id"];
    this.id = data["user_id"];
    this.weeklongID = data["weeklong_id"];
    this.username = data["username"];
    this.status = data["status"];
    this.poisoned = data["poisoned"];
    this.playerCode = data["player_code"];
    this.points = data["points"];
    this.kills = data["kills"];
    this.starveDate = data["starve_date"];
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

  getStatus(): string {
    return this.status;
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

   setStatus(status: string) {
     this.status = status;
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
  constructor(data: any) {
    super(data);
  }
}

export class Zombie extends Player{
  constructor(data: any) {
    super(data);
  }
}

export class Deceased extends Player{
  constructor(data: any) {
    super(data);
  }
}
