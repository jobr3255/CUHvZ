import React from "react";
import WeeklongDay from "../../models/WeeklongDay"
import FormattedText from "../layout/FormattedText"
import WeeklongMissionDetails from "./WeeklongMissionDetails"

import './Weeklong.css';

/**
 * WeeklongDayTab properties
 */
interface WeeklongDayTabProps {
  day: WeeklongDay
}

/**
 * Formats a WeeklongDay into html
 */
export default class WeeklongDayTab extends React.Component<WeeklongDayTabProps> {
  render() {
    var day = this.props.day;
    var onCamp, offCamp;
    var onCampMission = day.getOnCampusMission();
    var offCampMission = day.getOffCampusMission();
    if(onCampMission)
      onCamp = <WeeklongMissionDetails mission={onCampMission}/>
    if(offCampMission)
      offCamp = <WeeklongMissionDetails mission={offCampMission}/>
    return (
      <>
        <FormattedText text={day.getDescription()} />
        {onCamp}
        {offCamp}
      </>
    );
  }
}
