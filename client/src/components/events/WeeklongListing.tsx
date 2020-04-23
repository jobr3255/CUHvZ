import React from "react";
import EventDate from "./EventDate";
import EventListing, { EventListingProps } from "./EventListing";
import Weeklong from "../../models/Weeklong"

/**
 * WeeklongListing properties
 */
interface WeeklongListingProps extends EventListingProps {
  weeklong: Weeklong
}

/**
 * Listing view for a weeklong
 */
export default class WeeklongListing extends EventListing<WeeklongListingProps> {
  render() {
    var weeklong = this.props.weeklong;
    var pageLink = "/weeklong/" + weeklong.getID();
    var joinLink;
    var activeWeeklongData = sessionStorage.getItem('activeWeeklong');
    if (activeWeeklongData) {
      var activeWeeklong = new Weeklong(JSON.parse(activeWeeklongData));
      if (weeklong.getID() === activeWeeklong.getID()) {
        var lateSignupDate = new Date(activeWeeklong.getStartDate());
        var now = new Date();
        lateSignupDate.setDate(lateSignupDate.getDate() + 1);
        // Display join
        if (now.getTime() < lateSignupDate.getTime()) {
          joinLink = <>| <a href={`${pageLink}/join`} className="title-link orange">Join Now!</a></>;
        }
      }
    }

    var waiverLink;
    if (weeklong.getWaiver()) {
      waiverLink = <>| <a href={weeklong.getWaiver()} target="_blank" rel="noopener noreferrer">Waiver</a></>;
    }

    var titleLink = <><a className="title-link" href={pageLink}>{weeklong.getTitle()}</a> {joinLink}</>;
    var title;
    if (this.props.titleSize) {
      title = this.getTitle(titleLink, this.props.titleSize);
    } else {
      title = this.getTitle(titleLink, 4);
    }
    return (
      <div className="white">
        {title}
        <p>
          <EventDate
            startDate={weeklong.getStartDate()}
            endDate={weeklong.getEndDate()}
          /> | <a href={pageLink + "/stats"}>Player stats</a> {waiverLink}
        </p>
      </div>
    );
  }
}
