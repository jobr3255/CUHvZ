import { withIonLifeCycle } from '@ionic/react';
import React from 'react';
import LockinController from "../controllers/LockinController"

/**
 * LockinPage state variables
 */
interface LockinPageStates {
  lockin: JSX.Element | null
}

/**
 * LockinPage component
 */
class LockinPage extends React.Component<any, LockinPageStates> {

  constructor(props: any) {
    super(props);
    this.state = {
      lockin: null
    };
  }

  /**
   * Fires when component loads on page
   */
  async componentDidMount() {
    const { match: { params } } = this.props;
    var id = params["id"];
    var lockinController = new LockinController();
    var lockinView = await lockinController.getLockinView(id);
    this.setState({
      lockin: lockinView
    });
  }

  render() {
    return (
      <div className="container">
        <div className="row">
          <div className="content lightslide-box">
            {this.state.lockin}
          </div>
        </div>
      </div>
    );
  }
}

export default withIonLifeCycle(LockinPage);
