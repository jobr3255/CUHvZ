import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import WeeklongStatsController from "../controllers/WeeklongStatsController"

import Tabulator, { Tab } from "../components/Tabulator/Tabulator"

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
    if (this.state.weeklong) {
      var weeklong = this.state.weeklong;
      var weeklongController = new WeeklongStatsController();
      pageTitle = weeklong.getTitle();
      header = (
        <>
          <h1 className='stats-header'>
            <a className='white caps' href={`/weeklong/${weeklong.getID()}`}>{pageTitle}</a>
            <br />
            <span className="stats-header orange caps"> Player Statistics</span>
            <br />
            <span className='stats-header'>Zombie Stun Timer = {weeklongController.formatStunTimer(weeklong)}</span>
          </h1>
        </>
      );

      tabulator = (
        <Tabulator id="weeklong-stats">
          <Tab id="all-players" name={`All: ${weeklong.getPlayers().getAllPlayers().length}`} default>
            All players table
          </Tab>
          <Tab id="humans" name={`Humans: ${weeklong.getPlayers().getHumans().length}`} >
            Humans table
          </Tab>
          <Tab id="zombies" name={`Zombies: ${weeklong.getPlayers().getZombies().length}`}>
            Zombies table
          </Tab>
          <Tab id="deceased" name={`Deceased: ${weeklong.getPlayers().getDeceased().length}`}>
            Deceased table
          </Tab>
        </Tabulator>
      );
    }
    return (
      <div className="container">
        <Helmet>
          <title>{pageTitle}</title>
        </Helmet>
        <div className="content lightslide-box white">
          {header}
          {tabulator}
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(WeeklongStatsPage);
