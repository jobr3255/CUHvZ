import React from 'react';
import { BrowserRouter as Router, Switch, Route, Redirect, NavLink } from "react-router-dom";
import './Navbar.css';
import User from "../../models/User";
import Weeklong from "../../models/Weeklong";

import HomePage from '../../pages/HomePage';
import RulesPage from '../../pages/RulesPage';
import EventsPage from '../../pages/EventsPage';
import SignUpPage from '../../pages/SignUpPage';
import LoginPage from '../../pages/LoginPage';
import ProfilePage from '../../pages/ProfilePage';
import LockinPage from '../../pages/LockinPage';
import WeeklongPage from '../../pages/WeeklongPage';
import WeeklongStatsPage from '../../pages/WeeklongStatsPage';
import AdminPage from '../../pages/AdminPage';
import ActivationPage from '../../pages/ActivationPage';

import NotFound from '../errors/NotFound';
import JoinWeeklong from '../events/JoinWeeklong';

/**
 * Navbar properties
 */
interface NavbarProps {
  sessionUser: User | null,
  activeWeeklong: Weeklong | null,
  loginCallback: any,
  logoutCallback: any
}

/**
 * Navbar component
 */
export default class Navbar extends React.Component<NavbarProps, any> {

  render() {
    var profileButtons = [];
    var userClearance = false;
    var sessionUser = this.props.sessionUser;

    var activeWeeklong = this.props.activeWeeklong;
    var activeWeeklongLink;
    if(activeWeeklong){
      activeWeeklongLink = <li><NavLink exact className="nav-link" activeClassName="active-nav-link" to={`/weeklong/${activeWeeklong.getID()}`}>Weeklong</NavLink></li>;
    }

    if (sessionUser) {
      if (sessionUser.getClearance() > 0) {
        userClearance = true;
        profileButtons.push(<li key={3}><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/admin">Admin</NavLink></li>);
      }
      profileButtons.push(<li key={1}><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/profile">Profile</NavLink></li>);
      profileButtons.push(<li key={2}><button onClick={this.props.logoutCallback} className="nav-link">Logout</button></li>);
    } else {
      profileButtons.push(<li key={1}><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/login">Login</NavLink></li>);
      profileButtons.push(<li key={2}><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/signup">Sign up</NavLink></li>);
    }
    return (
      <div>
        <Router>
          <nav>
            <div className="nav-container">

              <span className="menu main-menu-container">
                <span className="dropdown-button-container">
                  <div className="menu-bar"></div>
                  <div className="menu-bar"></div>
                  <div className="menu-bar"></div>
                </span>
                <ul className="main-menu">
                  <li><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/">Home</NavLink></li>
                  <li><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/rules">Rules</NavLink></li>
                  <li><NavLink exact className="nav-link" activeClassName="active-nav-link" to="/events">Events</NavLink></li>
                  {activeWeeklongLink}
                </ul>
              </span>

              <span className="menu profile-menu-container">
                <div className="dropdown-button-container profile">
                  <div className="profile-head"></div>
                  <div className="profile-body"></div>
                </div>
                <ul className="profile-menu">
                  {profileButtons}
                </ul>
              </span>
            </div>
          </nav>
          <Switch>
            <Route path="/" exact component={HomePage} />

            <Route path="/rules" component={RulesPage} />
            <Route path="/events" component={EventsPage} />
            <ConditionalRoute path="/signup" component={<SignUpPage login={this.props.loginCallback} />} rerouteOn={sessionUser} reroute="/profile" />
            <ConditionalRoute path="/login" component={<LoginPage login={this.props.loginCallback} />} rerouteOn={sessionUser} reroute="/profile" />
            <ConditionalRoute path="/profile" component={<ProfilePage user={sessionUser} />} rerouteOn={sessionUser == null} reroute="/login" />
            <ConditionalRoute path="/admin" component={<AdminPage />} rerouteOn={!userClearance} reroute="/profile" />

            <Route path="/lockin/:id" component={LockinPage} />
            <Route path="/weeklong/:id/stats" component={WeeklongStatsPage} />
            <Route path="/weeklong/:id/join" component={JoinWeeklong} />
            <Route path="/weeklong/:id" component={WeeklongPage} />

            <Route path="/activate/:activationToken" component={ActivationPage} />

            <Route component={NotFound} />
          </Switch>
        </Router>
      </div>
    );
  }
}

class ConditionalRoute extends React.Component<any, any> {
  render() {
    return (
      <Route
        path={this.props.path}
        render={({ location }) =>
          !this.props.rerouteOn ? this.props.component : (
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
