import React, { Component } from 'react';
import {
  Switch,
  Route
} from "react-router-dom";

import Home from '../../pages/Home.js';

export default class Routes extends Component {
  render() {
    return(
      <Switch>
        <Route path="/" exact     component={Home}/>
      </Switch>
    );
  }
}
