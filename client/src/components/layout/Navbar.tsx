import React from 'react';
import { BrowserRouter as Router, Switch, Route, Redirect } from "react-router-dom";
// import Routes from './Routes';
import './Navbar.css';
import User from "../../models/User";

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
 * Navbar state variables
 */
interface NavbarStates {
  sessionUser: User | null
}

/**
 * Navbar component
 */
export default class Navbar extends React.Component<any, NavbarStates> {
  constructor(props: any) {
    super(props);
    this.state = {
      sessionUser: null
    };
    this.login = this.login.bind(this);
    this.logout = this.logout.bind(this);
  }

  /**
   * This fires before the componentDidMount method.
   * Sets the currentPage and prevPage storageSession variables so that the Tabs in the Tabulator object will rerender to the last tab opened if the page is refreshed
   */
  UNSAFE_componentWillMount() {
    var prevPage = sessionStorage.getItem('currentPage');
    var currentPage = window.location.href;
    sessionStorage.setItem("currentPage", currentPage);
    if(prevPage)
      sessionStorage.setItem("prevPage", prevPage);
    this.loadSessionUser();
  }

  /**
   * Loads a logged in user if one exists
   */
  loadSessionUser(){
    var userStr = sessionStorage.getItem('sessionUser');
    if(userStr){
      var userJSON = JSON.parse(userStr);
      var user = new User(userJSON);
      this.setState({
        sessionUser: user
      });
    }
  }

  /**
   * Clears the session of a user
   */
  login(userData: any){
    sessionStorage.setItem("sessionUser", JSON.stringify(userData));
    var user = new User(userData);
    this.setState({
      sessionUser: user
    });
  }

  /**
   * Clears the session of a user
   */
  logout(){
    sessionStorage.removeItem('sessionUser');
    this.setState({
      sessionUser: null
    });
  }

  render() {
    var profileButton, logoutButton, loginButton, signupButton;
    var profilePage;
    if(this.state.sessionUser){
      profilePage = <ProfilePage user={this.state.sessionUser}/>;
      profileButton = <li style={{float: 'right'}}><a id='profile_button' href='/profile'>Profile</a></li>
      logoutButton = <li style={{float: 'right'}}><button id='logout_button' onClick={this.logout}>Logout</button></li>
    }else{
      loginButton = <li style={{float: 'right'}}><a id='login_button' href='/login'>Login</a></li>;
      signupButton = <li style={{float: 'right'}}><a id='signup_button' href='/signup'>Sign Up</a></li>;
    }
    return(
      <div>
        <Router>
          <nav>
            <ul>
              <li><a href="/">Home</a></li>
              <li><a href="/rules">Rules</a></li>
              <li><a href="/events">Events</a></li>
              {logoutButton}
              {profileButton}
              {signupButton}
              {loginButton}
            </ul>
          </nav>
          <Switch>
            <Route path="/" exact component={HomePage} />

            <Route path="/rules" component={RulesPage} />
            <Route path="/events" component={EventsPage} />
            <ConditionalRoute path="/signup" component={<SignUpPage login={this.login}/>} rerouteOn={this.state.sessionUser} reroute="/profile"/>
            <ConditionalRoute path="/login" component={<LoginPage login={this.login}/>} rerouteOn={this.state.sessionUser} reroute="/profile"/>
            <ConditionalRoute path="/profile" component={profilePage} rerouteOn={this.state.sessionUser == null} reroute="/login"/>

            <Route path="/lockin/:id" component={LockinPage} />
            <Route path="/weeklong/:id/stats" component={WeeklongStatsPage} />
            <Route path="/weeklong/:id" component={WeeklongPage} />

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
