import React from "react";
import EventDate from "./EventDate";
import EventListing, { EventListingProps } from "./EventListing";
import Lockin from "../../models/Lockin"

interface LockinListingProps extends EventListingProps {
  lockin: Lockin
}

export default class LockinListing extends EventListing<LockinListingProps> {
  render() {
    var lockin = this.props.lockin;
    var pageLink = "/lockin/" + lockin.getID();
    var activeLinks = null;
    if(lockin.getState() === 2){
      var eventbriteLink = null;
      if(lockin.getEventbrite()){
        eventbriteLink = <>| <a href={lockin.getEventbrite()} target="_blank" rel="noopener noreferrer">Tickets</a></>;
      }
      var blasterEventbriteLink = null;
      if(lockin.getBlasterEventbrite()){
        blasterEventbriteLink = <>| <a href={lockin.getBlasterEventbrite()} target="_blank" rel="noopener noreferrer">Blaster Rental</a></>;
      }
      activeLinks = <>{eventbriteLink} {blasterEventbriteLink}</>;
    }
    var titleLink = <a className="title-link" href={pageLink}>{lockin.getTitle()}</a>;
    var title;
    if(this.props.titleSize){
      title = this.getTitle(titleLink, this.props.titleSize);
    }
    return (
      <div className="white">
        {title}
        <p>
          <EventDate
            type="lockin"
            startDate={lockin.getEventDate()}
          /> | <a href={lockin.getWaiver()}>Waiver</a> {activeLinks}
        </p>
      </div>
    );
  }
}
