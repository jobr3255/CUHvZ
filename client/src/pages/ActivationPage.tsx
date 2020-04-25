import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import { Helmet } from "react-helmet";
import ActivationController from "../controllers/ActivationController"

/**
 * WeeklongPage component
 */
class ActivationPage extends React.Component<any, any> {

  constructor(props: any) {
    super(props);
    this.state = {
      success: false,
      message: null
    };
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    const { match: { params } } = this.props;
    var activationToken = params["activationToken"];
    var controller = new ActivationController();
    var response = await controller.activateUser(activationToken);
    if(response){
      if(response["error"]){
        this.setState({
          success: false,
          message: `There was an error activating your account: ${response["error"]}`
        });
      }else{
        this.setState({
          success: true,
          message: "Thank you for activating your account!"
        });
      }
    }

  }

  render() {
    var statusHeader;
    var message = <div>{this.state.message}</div>
    if(this.state.success){
      statusHeader = <h3 className="activation-message activation-success">Account activated</h3>
    }else{
      statusHeader = <h3 className="activation-message activation-failed">Error</h3>
    }
    return (
      <div className="container">
        <Helmet>
          <title>Activate your account</title>
        </Helmet>
        <div className="content lightslide-box white">
          {statusHeader}
          {message}
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(ActivationPage);
