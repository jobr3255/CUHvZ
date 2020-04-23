import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Redirect } from "react-router-dom";

/**
 * JoinWeeklong component
 */
class JoinWeeklong extends React.Component<any, any> {

  render() {
    const { match: { params } } = this.props;
    var id = params["id"];
    sessionStorage.setItem('joinWeeklong', id);
    var redirect = <Redirect to={{ pathname: "/signup" }} />;
    if(sessionStorage.getItem('sessionUser')){
      redirect = <Redirect to={{ pathname: "/profile" }} />;
    }
    return (
      <>
        {redirect}
      </>
    );
  }
}

export default withIonLifeCycle(JoinWeeklong);
