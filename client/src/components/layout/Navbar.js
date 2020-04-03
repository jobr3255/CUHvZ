import React, { Component } from 'react';
import { BrowserRouter as Router } from "react-router-dom";
import { Helmet } from "react-helmet";

import Routes from './Routes.js';
import './Navbar.css';

export default class Navbar extends Component {
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
