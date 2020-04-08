
export default class WeeklongMission {
  private id: number;
  private day: string;
  private campus: string;
  private mission: string;
  private time: string;
  private location: string;
  private locationLink: string;
  private description: string;

  constructor(data: any) {
    this.id = data["id"];
    this.day = data["day"];
    this.mission = data["mission"];
    this.campus = data["campus"];
    this.time = data["time"];
    this.location = data["location"];
    this.locationLink = data["locationLink"];
    this.description = data["description"];
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

  getCampus(): string {
    return this.campus;
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

  getDescription(): string {
    return this.description;
  }

  /***************
      SETTERS
   ***************/

   setDay(day: string) {
     this.day = day;
   }

   setCampus(campus: string) {
     this.campus = campus;
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

   setDescription(desc: string) {
     this.description = desc;
   }
}
