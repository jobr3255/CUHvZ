import { withIonLifeCycle } from '@ionic/react';
import React, { Component } from 'react';
import { Helmet } from "react-helmet";

class Profile extends Component {
  render() {
    return (
      <div className="App signup lightslide">
        <Helmet>
            <title>Profile</title>
        </Helmet>
        <div className="container">

        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(Profile);
