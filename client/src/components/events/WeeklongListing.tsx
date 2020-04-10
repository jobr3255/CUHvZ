import React from "react";
import EventDate from "./EventDate";
import EventListing, { EventListingProps } from "./EventListing";
import Weeklong from "../../models/Weeklong"

interface WeeklongListingProps extends EventListingProps {
  weeklong: Weeklong
}

export default class WeeklongListing extends EventListing<WeeklongListingProps> {
  render() {
    var weeklong = this.props.weeklong;
    var pageLink = "/weeklong/" + weeklong.getID();
    // var activeLinks = null;
    // if(lockin.getState() === 2){
    //   var eventbriteLink = null;
    //   if(lockin.getEventbrite()){
    //     eventbriteLink = <>| <a href={lockin.getEventbrite()} target="_blank" rel="noopener noreferrer">Tickets</a></>;
    //   }
    //   var blasterEventbriteLink = null;
    //   if(lockin.getBlasterEventbrite()){
    //     blasterEventbriteLink = <>| <a href={lockin.getBlasterEventbrite()} target="_blank" rel="noopener noreferrer">Blaster Rental</a></>;
    //   }
    //   activeLinks = <>{eventbriteLink} {blasterEventbriteLink}</>;
    // }
    // <br/>
    // <span>Wanna play in this event
    //   <h3 style='margin: 0;'><a href='/profile.php?joinEvent=$weeklongID' >Join Now!</a>
    // </h3></span>
      // <br/>
      // <span>Late to the game? <a href='/profile.php?joinEvent=$weeklongID' >Join Now!</a></span>
    var titleLink = <a className="title-link" href={pageLink}>{weeklong.getTitle()}</a>;
    var title;
    if(this.props.titleSize){
      title = this.getTitle(titleLink, this.props.titleSize);
    }else{
      title = this.getTitle(titleLink, 4);
    }
    return (
      <div className="white">
        {title}
        <p>
          <EventDate
            type="weeklong"
            startDate={weeklong.getStartDate()}
            endDate={weeklong.getEndDate()}
          /> | <a href={pageLink + "/stats"}>Player stats</a>
        </p>
      </div>
    );
  }
}
