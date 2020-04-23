import WeeklongMission from "./WeeklongMission";

export default class WeeklongDay {
  private description: string
  private onCampusMission: WeeklongMission | undefined
  private offCampusMission: WeeklongMission | undefined

  constructor(description: string, onCamp?: WeeklongMission, offCamp?: WeeklongMission) {
    this.description = description || "";
    this.onCampusMission = onCamp;
    this.offCampusMission = offCamp;
  }

  /***************
      GETTERS
   ***************/

  getDescription(): string {
    return this.description;
  }

  getOnCampusMission(): WeeklongMission | undefined {
    return this.onCampusMission;
  }

  getOffCampusMission(): WeeklongMission | undefined {
    return this.offCampusMission;
  }

  /***************
      SETTERS
   ***************/

  setDescription(des: string) {
    this.description = des;
  }

  setOnCampusMission(mission: WeeklongMission) {
    this.onCampusMission = mission;
  }

  setOffCampusMission(mission: WeeklongMission) {
    this.offCampusMission = mission;
  }
}
