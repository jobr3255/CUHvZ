import React from "react";
import API from "../util/API";
import Weeklong from "../models/Weeklong"

/**
 * Controller for the EventsPage
 */
export default class AdminController {

  /**
   * Calls API and returns WeeklongListing objects
   */
  async getWeeklongs(): Promise<Weeklong[]> {
    let weeklongData = await API.get("/api/weeklongs")
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    var weeklongs = [];
    for (var data of weeklongData) {
      weeklongs.push(new Weeklong(data));
    }
    return weeklongs;
  }
}
