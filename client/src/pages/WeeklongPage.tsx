import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";

class WeeklongPage extends React.Component {
  render() {
    return (
      <div className="App signup lightslide">
        <Helmet>
            <title>Weeklong</title>
        </Helmet>
        <div className="container">

        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(WeeklongPage);