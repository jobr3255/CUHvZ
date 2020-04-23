import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import Tabulator, { Tab } from "../components/Tabulator/Tabulator"

/**
 * AdminPage component
 */
class AdminPage extends React.Component<any, any> {

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
  }

  render() {
    var tabs = [];

      tabs.push(
        <Tab key={1} name="Weeklongs" default>
        </Tab>
      );
      tabs.push(
        <Tab key={2} name="Users">
        </Tab>
      );
    return (
      <div className="container">
        <Helmet>
          <title>Admin</title>
        </Helmet>
        <div className="content lightslide-box white">
          <Tabulator id="admin-options">
            {tabs}
          </Tabulator>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(AdminPage);
