import React, { Component } from 'react';
import {
  Switch,
  Route
} from "react-router-dom";

import Home from '../../pages/Home.js';
import Rules from '../../pages/Rules.js';

export default class Routes extends Component {
  render() {
    return(
      <Switch>
        <Route path="/" exact     component={Home}/>
        <Route path="/rules"      component={Rules}/>
      </Switch>
    );
  }
}
