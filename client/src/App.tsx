import React, { Component } from 'react';
import { IonApp } from '@ionic/react';
import { Redirect } from "react-router-dom";

import API from "./util/API";
import Navbar from './components/layout/Navbar';
import Footer from './components/layout/Footer';
import User from "./models/User";
import Weeklong from "./models/Weeklong";

/* Styles */
import './theme/app.css';


/**
 * Navbar state variables
 */
interface AppStates {
  sessionUser: User | null,
  activeWeeklong: Weeklong | null
}

/**
 * Main entry component for the application
 */
export default class App extends Component<any, AppStates> {
  constructor(props: any) {
    super(props);
    this.state = {
      sessionUser: null,
      activeWeeklong: null
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
    if (prevPage)
      sessionStorage.setItem("prevPage", prevPage);
    this.loadSessionUser();
    this.loadActiveWeeklong();
  }

  /**
   * Loads an active weeklong if there is one
   */
  async loadActiveWeeklong() {
    sessionStorage.removeItem('activeWeeklong');
    let weeklongData = await API.get("/api/weeklong/active")
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return false;
      });
    if (weeklongData) {
      var activeWeeklong = new Weeklong(weeklongData);
      sessionStorage.setItem("activeWeeklong", JSON.stringify(weeklongData));
      this.setState({
        activeWeeklong: activeWeeklong
      });
    }
  }

  /**
   * Loads a logged in user if one exists
   */
  loadSessionUser() {
    var userStr = sessionStorage.getItem('sessionUser');
    if (userStr) {
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
  login(userData: any, password: string) {
    sessionStorage.setItem("sessionUser", JSON.stringify(userData));
    const token = Buffer.from(`${userData["username"]}:${password}`, 'utf8').toString('base64');
    sessionStorage.setItem("sessionToken", JSON.stringify(token));
    var user = new User(userData);
    this.setState({
      sessionUser: user
    });
  }

  /**
   * Clears the session of a user
   */
  logout() {
    sessionStorage.removeItem('sessionUser');
    sessionStorage.removeItem('sessionToken');
    this.setState({
      sessionUser: null
    });
  }

  /**
   * Render the application
   */
  render() {
    var redirect;
    if(sessionStorage.getItem('pageRedirect')){
      let link = sessionStorage.getItem('pageRedirect');
      redirect = <Redirect to={{ pathname: `${link}` }} />;
      sessionStorage.removeItem('pageRedirect');
    }
    return (
      <IonApp>
        {redirect}
        <Navbar
          loginCallback={this.login}
          logoutCallback={this.logout}
          sessionUser={this.state.sessionUser}
          activeWeeklong={this.state.activeWeeklong} />
        <Footer />
      </IonApp>
    );
  }
}
