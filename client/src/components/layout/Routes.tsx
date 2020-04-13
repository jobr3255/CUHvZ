import React from 'react';
import { Switch, Route } from "react-router-dom";

import HomePage from '../../pages/HomePage';
import RulesPage from '../../pages/RulesPage';
import EventsPage from '../../pages/EventsPage';
import SignUpPage from '../../pages/SignUpPage';
import LoginPage from '../../pages/LoginPage';
import ProfilePage from '../../pages/ProfilePage';
import LockinPage from '../../pages/LockinPage';
import WeeklongPage from '../../pages/WeeklongPage';
import WeeklongStatsPage from '../../pages/WeeklongStatsPage';
import NotFound from '../errors/NotFound';

/**
 * Maps urls to page components.
 * urls are checked in order listed in the Switch tag
 */
export default class Routes extends React.Component {
  render() {
    return (
      <Switch>
        <Route path="/" exact component={HomePage} />

        <Route path="/rules" component={RulesPage} />
        <Route path="/events" component={EventsPage} />
        <Route path="/signup" component={SignUpPage} />
        <Route path="/login" component={LoginPage} />
        <Route path="/profile" component={ProfilePage} />

        <Route path="/lockin/:id" component={LockinPage} />
        <Route path="/weeklong/:id/stats" component={WeeklongStatsPage} />
        <Route path="/weeklong/:id" component={WeeklongPage} />

        <Route component={NotFound} />
      </Switch>
    );
  }
}
