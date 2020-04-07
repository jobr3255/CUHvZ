import API from "../util/API";
import Weeklong from "../models/Weeklong"

export default class WeeklongController {

  async getWeeklong(id: number) {
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

  async getWeeklongDetails(id: number) {
    let weeklongData = await API.get(`/api/weeklong/${id}/details`)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    // var weeklong = new Weeklong(weeklongData);
    return weeklongData;
  }
}
