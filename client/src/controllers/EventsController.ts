// import React from "react";
// import API from "../assets/js/API.js"
// import WeeklongListing from "../components/events/WeeklongListing.js"
// import Weeklong from "../models/Weeklong.js"

export default class EventsController {

  // async getWeeklongListings(){
  //   let weeklongListings = await API.get("/api/weeklongs")
  //   .then(function (response) {
  //     if(response.status === 200){
  //       var weeklongListings = [];
  //       console.log(response.data);
  //       for (const weeklongData of response.data) {
  //         var weeklong = new Weeklong(weeklongData);
  //         weeklongListings.push(
  //           <WeeklongListing
  //             key={weeklong.getID()}
  //             title={weeklong.getTitle()}
  //             href={"/weeklong/" + weeklong.getID()}
  //             startDate={weeklong.getStartDate()}
  //             endDate={weeklong.getEndDate()} />
  //         );
  //       }
  //       return weeklongListings;
  //     }
  //     return [];
  //   });
  //   return weeklongListings;
  // }

  // getLockinListings(){
  //   API.get("/api/lockins")
  //   .then(function (response) {
  //     if(response.status == 200){
  //       return response.data;
  //     }
  //   })
  //   .catch(function (error) {
  //   });
  // }
}
