import React from "react";

export interface EventDateProps {
  type: string,
  startDate: string,
  endDate?: string
}

export default class EventDate extends React.Component<EventDateProps, any> {

  constructor(props: EventDateProps) {
    super(props);
  }

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

  private formatLockinDate(startDate: string){
    return this.formatDate(startDate) + ", 9pm - 3am";
  }

  render() {
    var date = null;
    if(this.props.type === "lockin"){
      date = this.formatLockinDate(this.props.startDate);
    }else if(this.props.type === "weeklong"){
      date = this.formatDate(this.props.startDate, this.props.endDate);
    }
    return (
      <span>
        {date}
      </span>
    );
  }
}
