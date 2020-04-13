import API from "../util/API";
import Weeklong from "../models/Weeklong"
import WeeklongMission from "../models/WeeklongMission";

/**
 * Controller for the WeeklongPage
 */
export default class WeeklongController {

  /**
   * Calls API and creates Weeklong object
   */
  async getWeeklong(id: number): Promise<Weeklong> {
    let weeklongData = await API.get(`/api/weeklong/${id}`)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    var weeklong = new Weeklong(weeklongData);
    return weeklong;
  }

  /**
   * Calls API and sets the weeklong details for a Weeklong object
   */
  async setWeeklongDetails(weeklong: Weeklong) {
    let weeklongDetailsData = await API.get(`/api/weeklong/${weeklong.getID()}/missions`)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    // console.log(weeklongDetailsData)
    var weeklongDetails = weeklong.getDetails();
    for (var data of weeklongDetailsData) {
      var weeklongDay = null;
      switch(data["day"]){
        case "monday" :
          weeklongDay = weeklongDetails.getMonday();
          break;
        case "tuesday" :
          weeklongDay = weeklongDetails.getTuesday();
          break;
        case "wednesday" :
          weeklongDay = weeklongDetails.getWednesday();
          break;
        case "thursday" :
          weeklongDay = weeklongDetails.getThursday();
          break;
        case "friday" :
          weeklongDay = weeklongDetails.getFriday();
          break;
      }
      if(weeklongDay){
        switch(data["campus"]){
          case "on" :
            weeklongDay.setOnCampusMission(new WeeklongMission(data));
            break;
          case "off" :
            weeklongDay.setOffCampusMission(new WeeklongMission(data));
            break;
        }
      }
    }
  }
}
