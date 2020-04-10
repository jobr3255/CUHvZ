import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import WeeklongController from "../controllers/WeeklongController"

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
    var weeklongController = new WeeklongController();
    var weeklong = await weeklongController.getWeeklong(id);
    await weeklongController.setWeeklongDetails(weeklong);
    // console.log(weeklong);
    this.setState({
      weeklong: weeklong
    });
  }

  render() {
    var pageTitle = "Weeklong";
    var header;
    var tabs = [];
    if (this.state.weeklong) {
      var weeklong = this.state.weeklong;
      var weeklongController = new WeeklongController();
      pageTitle = weeklong.getTitle();
      header = (
        <>
          <h1 className='stats-header'>
            <a className='white caps' href={`/weeklong/${weeklong.getID()}`}>{pageTitle}</a>
            <br/>
            <span className="stats-header orange caps"> Player Statistics</span>
            <br/>
            <span className='stats-header'>Zombie Stun Timer = {weeklongController.formatStunTimer(weeklong)}</span>
          </h1>
        </>
      );

      tabs.push(
        <Tab key={1} name="All" default>
          All players table
        </Tab>
      );
      tabs.push(
        <Tab key={2} name="Humans">
          Humans table
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Zombies">
          Zombies table
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Deceased">
          Deceased table
        </Tab>
      );

      // tabs.push(
      //   <Tab key={3} name="Activity">
      //     Activity table
      //   </Tab>
      // );
    }
    return (
      <div className="container">
        <Helmet>
          <title>{pageTitle}</title>
        </Helmet>
        <div className="content lightslide-box white">
          {header}
          <Tabulator id="weeklong-details">
            {tabs}
          </Tabulator>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(WeeklongStatsPage);
