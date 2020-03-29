import React, { Component } from 'react';
import {
  Switch,
  Route
} from "react-router-dom";

import Home from '../../pages/Home.js';
import Rules from '../../pages/Rules.js';
import Events from '../../pages/Events.js';
import SignUp from '../../pages/SignUp.js';
import Login from '../../pages/Login.js';
import Profile from '../../pages/Profile.js';

import NotFound from '../errors/NotFound.js';

export default class Routes extends Component {
  render() {
    return(
      <Switch>
        <Route path="/" exact     component={Home}/>
        <Route path="/rules"      component={Rules}/>
        <Route path="/events"     component={Events}/>
        <Route path="/signup"     component={SignUp}/>
        <Route path="/login"      component={Login}/>
        <Route path="/profile"    component={Profile}/>

        <Route                    component={NotFound} />
      </Switch>
    );
  }
}
