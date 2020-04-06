import React from "react";
import API from "../util/API";
import WeeklongListing from "../components/events/WeeklongListing"
import LockinListing from "../components/events/LockinListing"
import Weeklong from "../models/Weeklong"
import Lockin from "../models/Lockin"

export default class EventsController {

  async getWeeklongListings() {
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

  async getLockinListings() {
    let lockinData = await API.get("/api/lockins")
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    var lockins = [];
    for (var data of lockinData) {
      lockins.push(new Lockin(data));
    }
    var lockinListings = [];
    for (var lockin of lockins) {
      lockinListings.push(
        <LockinListing
          key={ lockin.getID() }
          id = { lockin.getID() }
          lockin = { lockin } />);
    }
    return lockinListings;
  }
}
