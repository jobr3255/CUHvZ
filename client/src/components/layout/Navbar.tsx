import React from 'react';
import { BrowserRouter as Router } from "react-router-dom";
import Routes from './Routes';
import './Navbar.css';

/**
 * Navbar component
 */
export default class Navbar extends React.Component {

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
  }

  render() {
    return(
      <div>
        <Router>
          <nav>
            <ul>
              <li><a href="/">Home</a></li>
              <li><a href="/rules">Rules</a></li>
              <li><a href="/events">Events</a></li>
              <li><a style={{float: 'right'}} id='login_button' href='/login'>Login</a></li>
              <li><a style={{float: 'right'}} id='signup_button' href='/signup'>Sign Up</a></li>
            </ul>
          </nav>
          <Routes/>
        </Router>
      </div>
    );
  }
}
