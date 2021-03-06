import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import User from "../models/User";
import ProfileController from "../controllers/ProfileController"

/**
 * ProfilePage properties
 */
interface ProfilePageProps {
  user: User
}

/**
 * ProfilePage component
 */
class ProfilePage extends React.Component<ProfilePageProps, any> {

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    var joinWeeklong = sessionStorage.getItem('joinWeeklong');
    if(joinWeeklong){
      sessionStorage.removeItem('joinWeeklong');
      console.log("Join weeklong "+joinWeeklong);
    }
  }

  render() {
    var user = this.props.user;
    return (
      <div>
        <Helmet>
          <title>Profile</title>
        </Helmet>
        <div className="container">
          <div className="row">

            <div className="two columns hide-mobile">
              <img src="images/skull.png" className="u-max-full-width" alt="Skull" />
            </div>
            <div className="ten columns hide-mobile">
              <p className="grey subheader">
                University of Colorado <strong>Boulder</strong>
              </p>
              <h1 className="section-heading deepgrey">
                Humans <span className="white">versus</span> Zombies
              </h1>
            </div>
            <p className="grey subheader">
              Welcome, {user.getUsername()}.
            </p>

          </div>
          <div className="lightslide-box user-profile">
            <table>
              <tbody>
                <tr>
                  <td>
                    <span className="subheader deeporange col-6">Username</span>
                    <span>{user.getUsername()}</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span className="subheader deeporange col-6">Email</span>
                    <span>{user.getEmail()}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(ProfilePage);
