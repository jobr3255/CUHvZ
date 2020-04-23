import React from "react";
import API from "../util/API";
import WeeklongListing from "../components/events/WeeklongListing"
import Weeklong from "../models/Weeklong"

/**
 * Controller for the EventsPage
 */
export default class AdminController {

  /**
   * Calls API and returns WeeklongListing objects
   */
  async getWeeklongListings(): Promise<JSX.Element[]> {
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
    var weeklongListings = [];
    for (var weeklong of weeklongs) {
      weeklongListings.push(
        <WeeklongListing
          key={ weeklong.getID() }
          id = { weeklong.getID() }
          weeklong = { weeklong } />);
    }
    return weeklongListings;
  }
}
