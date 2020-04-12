import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import WeeklongStatsController from "../controllers/WeeklongStatsController";
import Tabulator, { Tab } from "../components/Tabulator/Tabulator";
import Paginator from "../components/Paginator/Paginator";
import PlayersTable from "../components/tables/PlayersTable";
import Weeklong from "../models/Weeklong";
import Player from "../models/Player";

import "./Pages.css";

class WeeklongStatsPage extends React.Component<any, any> {

  constructor(props: any) {
    super(props);
    this.state = {
      weeklong: null
    };
  }

  async componentDidMount() {
    const { match: { params } } = this.props;
    var id = params["id"];
    var weeklongController = new WeeklongStatsController();
    var weeklong = await weeklongController.getWeeklong(id);
    await weeklongController.setPlayers(weeklong);
    this.setState({
      weeklong: weeklong
    });
  }

  render() {
    var pageTitle = "Weeklong";
    var header;
    var tabulator;
    var topPlayers;
    if (this.state.weeklong) {
      var weeklong: Weeklong = this.state.weeklong;
      var weeklongController = new WeeklongStatsController();
      pageTitle = weeklong.getTitle();
      header = (
        <>
          <h1 className='stats-header'>
            <a className='white caps' href={`/weeklong/${weeklong.getID()}`}>{pageTitle}</a>
            <br />
            <span className="orange caps"> Player Statistics</span>
            <br />
            <span>Zombie Stun Timer = {weeklongController.formatStunTimer(weeklong)}</span>
          </h1>
        </>
      );
      var allPlayers = weeklong.getPlayers().getAllPlayers();
      allPlayers.sort((a: Player, b: Player) => {
        let aP = a.getPoints();
        let bP = b.getPoints();
        if(a.getClearance() > 0)
          aP = 0;
        if(b.getClearance() > 0)
          bP = 0;
        return (aP < bP) ? 1 : -1
      });
      topPlayers = <PlayersTable id="all-players" players={[allPlayers[0],allPlayers[1],allPlayers[2]]} headers={["Username", "Points", "Hunger"]}/>
      allPlayers = weeklong.getPlayers().getAllPlayers();
      allPlayers.sort((a: Player, b: Player) => (a.getPoints() < b.getPoints()) ? 1 : -1);
      tabulator = (
        <Tabulator id="weeklong-stats">
          <Tab id="all-players" name={`All: ${allPlayers.length}`} default>
            <Paginator perPage={2} id="all-players">
              <PlayersTable id="all-players" players={allPlayers} headers={["Username", "Points", "Hunger"]}/>
            </Paginator>
          </Tab>
          <Tab id="humans" name={`Humans: ${weeklong.getPlayers().getHumans().length}`} >
            <PlayersTable id="humans" players={weeklong.getPlayers().getHumans()} headers={["Username", "Points", "Hunger"]}/>
          </Tab>
          <Tab id="zombies" name={`Zombies: ${weeklong.getPlayers().getZombies().length}`}>
            <PlayersTable id="zombies" players={weeklong.getPlayers().getZombies()} headers={["Username", "Type", "Kills", "Points", "Hunger"]}/>
          </Tab>
          <Tab id="deceased" name={`Deceased: ${weeklong.getPlayers().getDeceased().length}`}>
            <PlayersTable id="deceased" players={weeklong.getPlayers().getDeceased()} headers={["Username", "Kills", "Points", "Starved"]}/>
          </Tab>
        </Tabulator>
      );
    }
    var playerContainer = {
      width: "95%",
      padding: 0,
      margin: "auto",
      paddingTop: "5rem",
      paddingBottom: "5rem"
    }
    return (
      <div style={playerContainer}>
        <Helmet>
          <title>{pageTitle}</title>
        </Helmet>
        <div className="content lightslide-box white">
          {header}
          {topPlayers}
          {tabulator}
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(WeeklongStatsPage);
