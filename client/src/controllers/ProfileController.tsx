import API from "../util/API";

/**
 * Controller for the ProfilePage
 */
export default class ProfileController {

  /**
   * Calls API and returns Weeklong objects
   */
  async joinWeeklong(weeklongID: number): Promise<JSX.Element[]> {
    var postData = {
      weeklongID: weeklongID
    }
    let weeklongData = await API.post("/api/weeklongs", postData)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    return weeklongData;
  }
}
