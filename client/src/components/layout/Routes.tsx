import React from 'react';
import { Switch, Route, Redirect } from "react-router-dom";

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

import User from "../../models/User";

/**
 * Routes properties
 */
interface RoutesProps {
  sessionUser?: User | null
}

/**
 * Maps urls to page components.
 * urls are checked in order listed in the Switch tag
 */
export default class Routes extends React.Component<RoutesProps, any> {
  constructor(props: any) {
    super(props);
    this.login = this.login.bind(this);
  }

  /**
   * Clears the session of a user
   */
  login(userData: any){
    sessionStorage.setItem("sessionUser", JSON.stringify(userData));
  }

  render() {
    // var profileRoute = <Route path="/profile" component={LoginPage} />;
    if (this.props.sessionUser) {
      // profileRoute = <Route path="/profile" component={ProfilePage} />;
    }
    return (
      <Switch>
        <Route path="/" exact component={HomePage} />

        <Route path="/rules" component={RulesPage} />
        <Route path="/events" component={EventsPage} />
        <Route path="/signup" component={SignUpPage} />
        // <Route path="/login" render={(props) => <LoginPage {...props} login={this.login} />} />
        // <ConditionalRoute path="/profile" component={<ProfilePage/>} rerouteOn={this.props.sessionUser} reroute="/login"/>

        <Route path="/lockin/:id" component={LockinPage} />
        <Route path="/weeklong/:id/stats" component={WeeklongStatsPage} />
        <Route path="/weeklong/:id" component={WeeklongPage} />

        <Route component={NotFound} />
      </Switch>
    );
  }
}

class ConditionalRoute extends React.Component<any, any> {
  render() {
    return (
      <Route
        path={this.props.path}
        render={({ location }) =>
          this.props.rerouteOn ? this.props.component : (
              <Redirect
                to={{
                  pathname: this.props.reroute,
                  state: { from: location }
                }}
              />
            )
        }
      />
    );
  }
}
