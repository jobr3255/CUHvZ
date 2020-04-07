
export default class WeeklongMission {
  private id: number;
  private day: string ;
  private mission: string ;
  private time: string ;
  private location: string ;
  private locationLink: string ;

  constructor(data: any) {
    this.id = data["id"];
    this.day = data["day"];
    this.mission = data["mission"];
    this.time = data["time"];
    this.location = data["location"];
    this.locationLink = data["locationLink"];
  }

  /***************
      GETTERS
   ***************/

  getID(): number {
    return this.id;
  }

  getDay(): string {
    return this.day;
  }

  getMission(): string {
    return this.mission;
  }

  getTime(): string {
    return this.time;
  }

  getLocation(): string {
    return this.location;
  }

  getLocationLink(): string {
    return this.locationLink;
  }

  /***************
      SETTERS
   ***************/

   setDay(day: string) {
     this.day = day;
   }

   setMission(mission: string) {
     this.mission = mission;
   }

   setTime(time: string) {
     this.time = time;
   }

   setLocation(loc: string) {
     this.location = loc;
   }

   setLocationLink(locLink: string) {
     this.locationLink = locLink;
   }
}
