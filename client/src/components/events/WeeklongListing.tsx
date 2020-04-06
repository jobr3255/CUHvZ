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
    return (
      <div className="white">
        <h4 style={{margin: 0}}>
          <a className="title-link" href={pageLink}>{weeklong.getTitle()}</a>
        </h4>
        <p>
          <EventDate
            type="weeklong"
            startDate={weeklong.getStartDate()}
            endDate={weeklong.getEndDate()}
          /> | <a href={pageLink}>Mission Details</a> | <a href={pageLink + "/stats"}>Stats</a>
        </p>
      </div>
    );
  }
}
