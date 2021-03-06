import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import WeeklongController from "../controllers/WeeklongController"
import WeeklongListing from "../components/events/WeeklongListing"
import FormattedText from "../components/layout/FormattedText"
import WeeklongDayTab from "../components/events/WeeklongDayTab"
import Tabulator, { Tab } from "../components/Tabulator/Tabulator"

/**
 * WeeklongPage component
 */
class WeeklongPage extends React.Component<any, any> {

  constructor(props: any) {
    super(props);
    this.state = {
      weeklong: null
    };
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    const { match: { params } } = this.props;
    var id = params["id"];
    var weeklongController = new WeeklongController();
    var weeklong = await weeklongController.getWeeklong(id);
    await weeklongController.setWeeklongDetails(weeklong);
    this.setState({
      weeklong: weeklong
    });
  }

  render() {
    var pageTitle = "Weeklong";
    var header, details;
    var tabs = [];
    if (this.state.weeklong) {
      var weeklong = this.state.weeklong;
      pageTitle = weeklong.getTitle();
      header = <WeeklongListing
        key={weeklong.getID()}
        titleSize={3}
        id={weeklong.getID()}
        weeklong={weeklong} />

      details = <FormattedText text={weeklong.getDetails().getDescription()} />

      tabs.push(
        <Tab key={1} name="Details" default>
          {details}
        </Tab>
      );
      var weeklongDetails = weeklong.getDetails();
      tabs.push(
        <Tab key={2} name="Monday">
          <WeeklongDayTab day={weeklongDetails.getMonday()} />
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Tuesday">
          <WeeklongDayTab day={weeklongDetails.getTuesday()} />
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Wednesday">
          <WeeklongDayTab day={weeklongDetails.getWednesday()} />
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Thursday">
          <WeeklongDayTab day={weeklongDetails.getThursday()} />
        </Tab>
      );

      tabs.push(
        <Tab key={3} name="Friday">
          <WeeklongDayTab day={weeklongDetails.getFriday()} />
        </Tab>
      );
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

export default withIonLifeCycle(WeeklongPage);
