import React, { Component } from 'react';
import {
  Switch,
  Route
} from "react-router-dom";

import Home from '../../pages/Home';
import Rules from '../../pages/Rules';
import Events from '../../pages/Events';
import SignUp from '../../pages/SignUp';
import Login from '../../pages/Login';
import Profile from '../../pages/Profile';

import NotFound from '../errors/NotFound';

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
