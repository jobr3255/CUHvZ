import React from "react";

/**
 * EventDate properties
 */
export interface EventDateProps {
  startDate: string,
  endDate?: string
}

/**
 * Formats dates for display for a weeklong or lockin event
 */
export default class EventDate extends React.Component<EventDateProps, any> {

  /**
   * Adds the correct ordinal to a number
   */
  private addOrdinal(num: any): string {
    num += "";
    var lastNum = num.substring(num.length-1, num.length);
    if(lastNum === "1")
      return num + "st";
    else if(lastNum === "2")
      return num + "nd";
    else if(lastNum === "3")
      return num + "rd";
    else
      return num + "th";
  }

  /**
   * Formats start and end dates
   */
  private formatDate(startDateString:string, endDateString?: string): string {
    var monthNames = [
      "January", "February", "March",
      "April", "May", "June", "July",
      "August", "September", "October",
      "November", "December"];
    var startDate = new Date(startDateString);
    var day = this.addOrdinal(startDate.getDate());
    var month = monthNames[startDate.getMonth()];
    var year = startDate.getFullYear();
    if(endDateString != null){
      return month + " " + day + " - " + this.formatDate(endDateString);
    }
    return month + " " + day + ", " + year + "";
  }

  render() {
    var date = null;
    if(this.props.endDate){
      date = this.formatDate(this.props.startDate, this.props.endDate);
    }else{
      date = this.formatDate(this.props.startDate) + ", 9pm - 3am";
    }
    return (
      <span>
        {date}
      </span>
    );
  }
}
