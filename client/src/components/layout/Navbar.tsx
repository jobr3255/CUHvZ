import React from 'react';
import { BrowserRouter as Router } from "react-router-dom";

import Routes from './Routes';
import './Navbar.css';

export default class Navbar extends React.Component {

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
