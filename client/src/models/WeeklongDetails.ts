import WeeklongDay from "./WeeklongDay";

export default class WeeklongDetails {
  private description: string;
  private monday: WeeklongDay;
  private tuesday: WeeklongDay;
  private wednesday: WeeklongDay;
  private thursday: WeeklongDay;
  private friday: WeeklongDay;

  constructor(data: any) {
    this.description = data["details"];
    this.monday = new WeeklongDay(data["monday"]);
    this.tuesday = new WeeklongDay(data["tuesday"]);
    this.wednesday = new WeeklongDay(data["wednesday"]);
    this.thursday = new WeeklongDay(data["thursday"]);
    this.friday = new WeeklongDay(data["friday"]);
  }

  /***************
      GETTERS
   ***************/

  getDescription(): string {
    return this.description;
  }

  getMonday(): WeeklongDay {
    return this.monday;
  }

  getTuesday(): WeeklongDay {
    return this.tuesday;
  }

  getWednesday(): WeeklongDay {
    return this.wednesday;
  }

  getThursday(): WeeklongDay {
    return this.thursday;
  }

  getFriday(): WeeklongDay {
    return this.friday;
  }

  /***************
      SETTERS
   ***************/

  setWeeklongDays(data: any) {
  // this.monday = new WeeklongDay(data["moday"]);
    for (var weeklongMissionData of data) {
      // this.monday = new WeeklongDay(data["moday"]);
    }
  }

  setDescription(des: string) {
    this.description = des;
  }

  setMonday(day: WeeklongDay) {
    this.monday = day;
  }

  setTuesday(day: WeeklongDay) {
    this.tuesday = day;
  }

  setWednesday(day: WeeklongDay) {
    this.wednesday = day;
  }

  setThursday(day: WeeklongDay) {
    this.thursday = day;
  }

  setFriday(day: WeeklongDay) {
    this.friday = day;
  }
}
