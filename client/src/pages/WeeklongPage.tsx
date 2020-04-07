import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import WeeklongController from "../controllers/WeeklongController"
import WeeklongListing from "../components/events/WeeklongListing"
import FormattedText from "../components/layout/FormattedText"

class WeeklongPage extends React.Component<any,any> {

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
    var weeklongDetails = await weeklongController.getWeeklongDetails(id);
    console.log(weeklongDetails);
    this.setState({
      weeklong: weeklong
    });
  }

  render() {
    var pageTitle = "Weeklong";
    var header;
    var details;
    if(this.state.weeklong){
      var weeklong = this.state.weeklong;
      pageTitle = weeklong.getTitle();
      header = <WeeklongListing
        key={ weeklong.getID() }
        titleSize={3}
        id = { weeklong.getID() }
        weeklong = { weeklong } />

      details = <FormattedText text={weeklong.getDetails().getDescription()} />
    }
    return (
      <div className="App signup lightslide">
        <Helmet>
            <title>{pageTitle}</title>
        </Helmet>
        <div className="container">
            <div className="row">
              <div className="content lightslide-box">
                {header}
                {details}
              </div>
            </div>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(WeeklongPage);
