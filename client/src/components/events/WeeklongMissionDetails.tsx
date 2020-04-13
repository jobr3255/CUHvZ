import React from "react";
import WeeklongMission from "../../models/WeeklongMission"
import FormattedText from "../layout/FormattedText"

import './Weeklong.css';

/**
 * WeeklongMissionDetails properties
 */
interface WeeklongMissionDetailsProps {
  mission: WeeklongMission
}

/**
 * Formats the display for a single weeklong mission
 */
export default class WeeklongMissionDetails extends React.Component<WeeklongMissionDetailsProps> {
  render() {
    var mission = this.props.mission;
      var campusText;
      if(mission.getCampus() === "on"){
        campusText = "On Campus";
      }else if(mission.getCampus() === "off"){
        campusText = "Off Campus";
      }
      var campus = <h5 style={{margin: 0}}>{campusText}</h5>

      var missionDetails = "";
      if(mission.getMission())
        missionDetails = `Mission: ${mission.getMission()}`

      if(mission.getLocationLink()){
        missionDetails += "\n";
        missionDetails += `Location: LINK[${mission.getLocation()}][${mission.getLocationLink()}]`
      }else if(mission.getLocation()){
        missionDetails += "\n";
        missionDetails += `Location: ${mission.getLocation()}`
      }

      if(mission.getTime()){
        missionDetails += "\n";
        missionDetails += `Time: ${mission.getTime()}`
      }

      if(mission.getDescription()){
        if(missionDetails.trim())
          missionDetails += "\n";
        missionDetails += `${mission.getDescription()}`
      }
    return (
      <div className="mission-details">
        {campus}
        <FormattedText text={missionDetails} />
      </div>
    );
  }
}
